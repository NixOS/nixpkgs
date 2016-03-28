#! /bin/sh
# Part of NixPkgs package collection
# This script can be used at your option under the same license as NixPkgs or 
# under MIT/X11 license

eval "$NIX_LISP_PREHOOK"

NIX_LISP_COMMAND="$1"
shift

[ -z "$NIX_LISP" ] && NIX_LISP="${NIX_LISP_COMMAND##*/}"

export NIX_LISP NIX_LISP_LOAD_FILE NIX_LISP_EXEC_CODE NIX_LISP_COMMAND NIX_LISP_FINAL_PARAMETERS

test -n "$NIX_LISP_LD_LIBRARY_PATH" &&
	export LD_LIBRARY_PATH="$LD_LIBRARY_PATH${LD_LIBRARY_PATH+:}$NIX_LISP_LD_LIBRARY_PATH"

case "$NIX_LISP" in
	sbcl)
		NIX_LISP_LOAD_FILE="--load"
		NIX_LISP_EXEC_CODE="--eval"
                NIX_LISP_QUIT="(quit)"
		NIX_LISP_FINAL_PARAMETERS=
		;;
	ecl)
		NIX_LISP_LOAD_FILE="-load"
		NIX_LISP_EXEC_CODE="-eval"
                NIX_LISP_QUIT="(quit)"
		NIX_LISP_FINAL_PARAMETERS=
		;;
	clisp)
		NIX_LISP_LOAD_FILE="-c -l"
		NIX_LISP_EXEC_CODE="-x"
                NIX_LISP_QUIT="(quit)"
		NIX_LISP_FINAL_PARAMETERS="-repl"
		;;
esac

NIX_LISP_ASDF_REGISTRY_CODE="
  (progn
    (setf asdf:*default-source-registries* '(asdf/source-registry:environment-source-registry))
    (asdf:initialize-source-registry)
    )
"

NIX_LISP_ASDF="${NIX_LISP_ASDF:-@asdf@}"

[ -z "$NIX_LISP_SKIP_CODE" ] && "$NIX_LISP_COMMAND" $NIX_LISP_EARLY_OPTIONS \
	$NIX_LISP_EXEC_CODE "(load \"$NIX_LISP_ASDF/lib/common-lisp/asdf/build/asdf.lisp\")" \
	$NIX_LISP_EXEC_CODE "$NIX_LISP_ASDF_REGISTRY_CODE" \
	$NIX_LISP_FINAL_PARAMETERS \
	"$@"
