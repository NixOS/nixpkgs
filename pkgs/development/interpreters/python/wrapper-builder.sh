source $stdenv/setup

preConfigure() {
    PYTHONPATH='$(
        # activate site if installed
        bindir=$(dirname "$0")
        pysite="$bindir/pysite"
        relpath=$(test -x "$pysite" && "$pysite" path)
        echo -n ${relpath:+"$relpath":}
)'"$PYTHONPATH"
}

genericBuild
