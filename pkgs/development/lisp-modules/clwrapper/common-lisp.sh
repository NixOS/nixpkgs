#! /bin/sh

"$(dirname "$0")"/cl-wrapper.sh "${NIX_LISP_COMMAND:-sbcl}" "$@"
