#! /bin/sh

[ -z "$NIX_QUICKLISP_DIR" ] && {
  export NIX_QUICKLISP_DIR="$(mktemp -d --tmpdir nix-quicklisp.XXXXXX)"
}

[ -f "$NIX_QUICKLISP_DIR/setup.lisp" ] || {
  "$(dirname "$0")/quicklisp-beta-env.sh" "$NIX_QUICKLISP_DIR" &> /dev/null < /dev/null
}

name="$1"

sbcl --noinform --load "$NIX_QUICKLISP_DIR"/setup.lisp --eval "(ql:quickload :$name)" \
    --eval "(format t \"~a~%\" (or (asdf::system-description (asdf::find-system \"$name\")) \"\"))" \
    --eval '(quit)' --script |
    tee /dev/stderr | tail -n 1
