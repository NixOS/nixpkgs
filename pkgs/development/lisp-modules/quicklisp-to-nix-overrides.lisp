(defparameter testnames (make-hash-table :test 'equal))
(setf
  (gethash "cxml-xml" testnames) "cxml"
  (gethash "cxml-dom" testnames) "cxml"
  (gethash "cxml-test" testnames) "cxml"
  (gethash "cxml-klacks" testnames) "cxml"
  (gethash "cl-async-base" testnames) "cl-async"
  (gethash "cl-async-util" testnames) "cl-async"
  )
