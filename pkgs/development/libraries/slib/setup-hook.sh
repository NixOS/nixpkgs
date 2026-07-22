addSlibPath () {
    if test -f "$1/lib/slib/slibcat"
    then
        export SCHEME_LIBRARY_PATH="$1/lib/slib/"
        echo "SLIB found in \`$1'; setting \$SCHEME_LIBRARY_PATH to \`$SCHEME_LIBRARY_PATH'"

        # This is needed so that `(load-from-path "slib/guile.init")' works.
        export GUILE_LOAD_PATH="$1/lib:$GUILE_LOAD_PATH"
        echo "SLIB: setting \$GUILE_LOAD_PATH to \`$GUILE_LOAD_PATH'"
    fi
}

addEnvHooks "$hostOffset" addSlibPath
