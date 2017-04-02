NIX_LISP_ASDF="@asdf@"

CL_SOURCE_REGISTRY="${CL_SOURCE_REGISTRY:+$CL_SOURCE_REGISTRY:}@asdf@/lib/common-lisp/asdf/:@asdf@/lib/common-lisp/asdf/uiop/"
ASDF_OUTPUT_TRANSLATIONS="@asdf@/lib/common-lisp/:@out@/lib/common-lisp-compiled/"

addASDFPaths () {
    for j in "$1"/lib/common-lisp/*; do
	if [ -d "$j" ]; then
            CL_SOURCE_REGISTRY="$j/:$CL_SOURCE_REGISTRY"
            if [ -d "$(dirname "$(dirname "$j")")/common-lisp-compiled/$(basename "$j")" ]; then
              ASDF_OUTPUT_TRANSLATIONS="$j:$(dirname "$(dirname "$j")")/common-lisp-compiled/$(basename "$j")${ASDF_OUTPUT_TRANSLATIONS:+:}$ASDF_OUTPUT_TRANSLATIONS"
            fi
	fi
    done
}

setLisp () {
    if [ -z "$NIX_LISP_COMMAND" ]; then 
      for j in "$1"/bin/*; do
          case "$(basename "$j")" in
              sbcl) NIX_LISP_COMMAND="$j" ;;
              ecl) NIX_LISP_COMMAND="$j" ;;
              clisp) NIX_LISP_COMMAND="$j" ;;
          esac
      done
    fi
    if [ -z "$NIX_LISP" ]; then 
        NIX_LISP="${NIX_LISP_COMMAND##*/}"
    fi
}

collectNixLispLDLP () {
     if echo "$1/lib"/lib*.so* | grep . > /dev/null; then
	 export NIX_LISP_LD_LIBRARY_PATH="$NIX_LISP_LD_LIBRARY_PATH${NIX_LISP_LD_LIBRARY_PATH:+:}$1/lib"
     fi
}

export NIX_LISP_COMMAND NIX_LISP CL_SOURCE_REGISTRY NIX_LISP_ASDF ASDF_OUTPUT_TRANSLATIONS

envHooks+=(addASDFPaths setLisp collectNixLispLDLP)

mkdir -p "$HOME"/.cache/common-lisp || HOME="$TMP/.temp-$USER-home"
mkdir -p "$HOME"/.cache/common-lisp
