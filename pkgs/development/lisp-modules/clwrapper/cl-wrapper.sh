#!@stdenv_shell@
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

declare -a NIX_LISP_FINAL_PARAMETERS;

case "$NIX_LISP" in
	sbcl)
		NIX_LISP_LOAD_FILE="--load"
		NIX_LISP_EXEC_CODE="--eval"
                NIX_LISP_QUIT="(quit)"
                NIX_LISP_NODEBUG='--non-interactive'
		NIX_LISP_FINAL_PARAMETERS=
                NIX_LISP_FASL_TYPE="fasl"
		;;
	ecl)
		NIX_LISP_LOAD_FILE="-load"
		NIX_LISP_EXEC_CODE="-eval"
                NIX_LISP_QUIT="(quit)"
                NIX_LISP_NODEBUG='--nodebug'
		NIX_LISP_FINAL_PARAMETERS=
                NIX_LISP_FASL_TYPE="fas"
		;;
	clisp)
		NIX_LISP_LOAD_FILE="-c -l"
		NIX_LISP_EXEC_CODE="-x"
                NIX_LISP_QUIT="(quit)"
                NIX_LISP_NODEBUG='-on-error exit'
		NIX_LISP_FINAL_PARAMETERS="-repl"
                NIX_LISP_FASL_TYPE="fas"
		;;
	lx86cl64)
		NIX_LISP_LOAD_FILE="-l"
		NIX_LISP_EXEC_CODE="-e"
                NIX_LISP_QUIT="(quit)"
                NIX_LISP_NODEBUG='-b'
		NIX_LISP_FINAL_PARAMETERS=
                NIX_LISP_FASL_TYPE="lx64fsl"
		;;
	lx86cl)
		NIX_LISP_LOAD_FILE="-l"
		NIX_LISP_EXEC_CODE="-e"
                NIX_LISP_QUIT="(quit)"
                NIX_LISP_NODEBUG='-b'
		NIX_LISP_FINAL_PARAMETERS=
                NIX_LISP_FASL_TYPE="lx32fsl"
		;;
	abcl)
		NIX_LISP_LOAD_FILE="--load"
		NIX_LISP_EXEC_CODE="--eval"
                NIX_LISP_QUIT="(quit)"
                NIX_LISP_NODEBUG=''
		NIX_LISP_FINAL_PARAMETERS=
                NIX_LISP_FASL_TYPE="abcl"
		;;
esac

NIX_LISP_ASDF_REGISTRY_CODE="
  (progn
    #+asdf3 (setf asdf:*default-source-registries*
      '(asdf/source-registry:environment-source-registry))
    (asdf:initialize-source-registry)
    )
"

NIX_LISP_ASDF="${NIX_LISP_ASDF:-@out@}"

nix_lisp_run_single_form(){
  NIX_LISP_FINAL_PARAMETERS=("$NIX_LISP_EXEC_CODE" "$1"
    "$NIX_LISP_EXEC_CODE" "$NIX_LISP_QUIT" $NIX_LISP_NODEBUG)
}

eval "$NIX_LISP_PRELAUNCH_HOOK"

[ -z "$NIX_LISP_SKIP_CODE" ] && "$NIX_LISP_COMMAND" $NIX_LISP_EARLY_OPTIONS \
	$NIX_LISP_EXEC_CODE "${NIX_LISP_ASDF_LOAD:-"(load \"$NIX_LISP_ASDF/lib/common-lisp/asdf/build/asdf.$NIX_LISP_FASL_TYPE\")"}" \
	$NIX_LISP_EXEC_CODE "$NIX_LISP_ASDF_REGISTRY_CODE" \
	${NIX_LISP_FINAL_PARAMETERS[*]:+"${NIX_LISP_FINAL_PARAMETERS[@]}"} \
	"$@"
