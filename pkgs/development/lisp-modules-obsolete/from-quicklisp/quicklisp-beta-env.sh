#! /bin/sh

WORK_DIR=$(mktemp -d "/tmp/ql-venv-XXXXXX")
mkdir -p "${1:-.}"
TARGET="$(cd "${1:-.}"; pwd)"

curl http://beta.quicklisp.org/quicklisp.lisp > "$WORK_DIR/ql.lisp"

sbcl --noinform \
     --load "$WORK_DIR/ql.lisp" \
     --eval "(quicklisp-quickstart:install :path \"$TARGET/\")" \
     --eval "(cl-user::quit)" \
     --script


rm -rf "$WORK_DIR"
