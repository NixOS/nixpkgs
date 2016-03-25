#! /bin/sh

"$(dirname "$0")"/cl-wrapper.sh "${NIX_LISP_COMMAND:-$(ls "@lisp@/bin"/* | head -n 1)}" "$@"
