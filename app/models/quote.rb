class Quote < ApplicationRecord
  validates :name, presence: true

  scope :ordered, -> { order(id: :desc) }
  #! after_create_commit -> { broadcast_prepend_to "quotes", partial: "quotes/quote", locals: { quote: self }, target: "quotes" }
  # target: 'quotes' automatically replaces with ModelName.Plural 

  #! after_create_commit -> { broadcast_prepend_to "quotes", partial: "quotes/quote", locals: { quote: self } }

  # The partial default value is equal to calling to_partial_path on an instance of the model, which by default in Rails for our Quote model is equal to "quotes/quote".

  # The locals default value is equal to { model_name.element.to_sym => self } which, in in the context of our Quote model, is equal to { quote: self }.
  #  * Updates the pages automatically after a new quote is created.
  #! after_create_commit -> { broadcast_prepend_to "quotes" }

  # * Updates the page in realtime.
  #! after_update_commit -> { broadcast_replace_to "quotes" }

  # * Updates the page realtime when a quote is deleted.
  #! after_destroy_commit -> { broadcast_remove_to "quotes" }


  # * Makes the broadcasts part asynchronous using Background Jobs.
  # ! after_create_commit -> { broadcast_prepend_later_to "quotes" }
  # ! after_update_commit -> { broadcast_replace_later_to "quotes" }
  # ! after_destroy_commit -> { broadcast_remove_to "quotes" }

  #* these three callbacks are equivalent to this single line of code
  #* this means that we want to broadcast quote creations, updates, and deletions to the "quotes" stream asynchronously.
  
  broadcasts_to ->(quote) { "quotes" }, inserts_by: :prepend
end