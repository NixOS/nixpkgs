#! /bin/sh

source "@out@"/bin/cl-wrapper.sh "${NIX_LISP_COMMAND:-$(ls "@lisp@/bin"/* | head -n 1)}" "$@"
