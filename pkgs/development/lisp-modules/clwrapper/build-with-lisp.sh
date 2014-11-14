#! /bin/sh
# Part of NixPkgs package collection
# This script can be used at your option under the same license as NixPkgs or
# under MIT/X11 license

lisp="$1"
systems="$2"
target="$3"
code="$4"

NIX_LISP_SKIP_CODE=1 NIX_LISP_COMMAND="$lisp" source "$(dirname "$0")/cl-wrapper.sh"

NIX_LISP_BUILD_CODE=

case "$NIX_LISP" in
        sbcl)
                NIX_LISP_BUILD_CODE="(progn
                  (sb-ext:with-unlocked-packages (:sb-sys :sb-alien)
                    (let*
                      (
                        (old-fn (symbol-function 'sb-alien::dlopen-or-lose))
                        (old-ldlp #.(sb-posix:getenv \"LD_LIBRARY_PATH\"))
                        (ldlp-merged nil)
                        )
                        (defun sb-alien::dlopen-or-lose (&rest args)
                          (or
                            (ignore-errors (progn (apply old-fn args)))
                            (and 
                              args
                              (loop
                                for path in (list $(echo "$NIX_LISP_LD_LIBRARY_PATH" | sed -e 's/:/" "/g; s/^/"; s/$/"'))
                                for try := (apply old-fn 
                                             (format nil "~a/~a" path (first args))
                                             (cdr args))
                                )
                               )
                            )
                          )
                      ))
                  (sb-ext:save-lisp-and-die \"$target\"
                  :toplevel (lambda ()
                    (setf common-lisp:*standard-input* (sb-sys::make-fd-stream 0 :input t :buffering :line))
                    (setf common-lisp:*standard-output* (sb-sys::make-fd-stream 1 :output t :buffering :line))
                    $code)
                    :executable t :save-runtime-options t :purify t))"
                systems=":sb-posix $systems"
                ;;
        ecl)
                NIX_LISP_BUILD_CODE="(asdf:make-build (first (list $systems)) :type :program :monolithic nil :epilogue-code '(progn (defpackage :asdf/image) $code) :move-here \"$target\")"
                ;;
        clisp)
                NIX_LISP_BUILD_CODE="(ext:saveinitmem \"$target\" :norc t :init-function (lambda () $code (ext:bye)) :script nil :executable 0)"
                ;;
esac

"$lisp" \
  "$NIX_LISP_EXEC_CODE" "(require :asdf)" \
  "$NIX_LISP_EXEC_CODE" "(load \"$NIX_LISP_ASDF/lib/common-lisp/asdf/build/asdf.lisp\")" \
  "$NIX_LISP_EXEC_CODE" "(mapcar 'require (list $systems))" \
  "$NIX_LISP_EXEC_CODE" "$NIX_LISP_BUILD_CODE" \
  "$NIX_LISP_EXEC_CODE" "(quit)"
