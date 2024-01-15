#! /usr/bin/env bash

op=
end_param=
args=()
cmd_args=()

while let "$#"; do
    if test -n "$end_param" || test "$1" = "${1#--}"; then
        if test -n "$op"; then
            args[${#args[@]}]="$1";
        else
            op="$1"
        fi
        shift
    else
        case "$1" in
            --)
                end_param=1; shift;
            ;;
            --quicklisp-dir)
                NIX_QUICKLISP_DIR="$2";
                shift; shift;
            ;;
            --help)
                echo "Operation: init, run, update, install {system-name}"
                exit 0;
            ;;
            *)
                echo "Unknown parameter [$1]" >&2
                exit 2;
            ;;
        esac
    fi
done

NIX_QUICKLISP_DIR="${NIX_QUICKLISP_DIR:-${HOME}/quicklisp}"

case "$op" in
    '') echo "Specify an operation: init, install, run, update"
    ;;
    install)
        NIX_LISP_SKIP_CODE=1 source "@clwrapper@/bin/common-lisp.sh";

        cmd_args[${#cmd_args[@]}]="$NIX_LISP_EXEC_CODE"
        cmd_args[${#cmd_args[@]}]="(load \"$NIX_QUICKLISP_DIR/setup.lisp\")"
        for i in "${args[@]}"; do
            cmd_args[${#cmd_args[@]}]="$NIX_LISP_EXEC_CODE"
            cmd_args[${#cmd_args[@]}]="(ql:quickload :$i)"
        done
        cmd_args[${#cmd_args[@]}]="$NIX_LISP_EXEC_CODE"
        cmd_args[${#cmd_args[@]}]="$NIX_LISP_QUIT"

        "@clwrapper@/bin/common-lisp.sh" "${cmd_args[@]}"
    ;;
    update)
        NIX_LISP_SKIP_CODE=1 source "@clwrapper@/bin/common-lisp.sh"

        ln -sfT "@out@/lib/common-lisp/quicklisp/asdf.lisp" "$NIX_QUICKLISP_DIR/asdf.lisp"
        cp -f "@out@/lib/common-lisp/quicklisp/setup.lisp" "$NIX_QUICKLISP_DIR/setup.lisp"

        if test -d "$NIX_QUICKLISP_DIR/quicklisp"; then
            mv "$NIX_QUICKLISP_DIR/quicklisp"{,-old-$(date +%Y%m%d-%H%M%S)}
        fi

        cp -rfT "@out@/lib/common-lisp/quicklisp/quicklisp" "$NIX_QUICKLISP_DIR/quicklisp"

        "@clwrapper@/bin/common-lisp.sh" "$NIX_LISP_EXEC_CODE" \
          "(load \"$NIX_QUICKLISP_DIR/setup.lisp\")" "$NIX_LISP_EXEC_CODE" \
          "(ql:update-all-dists)" "$NIX_LISP_EXEC_CODE" "$NIX_LISP_QUIT"
    ;;
    init)
        mkdir -p "$NIX_QUICKLISP_DIR"/{dists/quicklisp,tmp,local-projects}
        echo 1 > "$NIX_QUICKLISP_DIR/dists/quicklisp/enabled.txt"
        cp -f "@out@/lib/common-lisp/quicklisp/quicklisp-distinfo.txt" \
          "$NIX_QUICKLISP_DIR/dists/quicklisp/distinfo.txt"

        NIX_QUICKLISP_DIR="$NIX_QUICKLISP_DIR" "$0" update
    ;;
    run)
        NIX_LISP_SKIP_CODE=1 source "@clwrapper@/bin/common-lisp.sh"
        "@clwrapper@/bin/common-lisp.sh" "$NIX_LISP_EXEC_CODE" \
          "(load \"$NIX_QUICKLISP_DIR/setup.lisp\")" "${args[@]}"
    ;;
esac
