# Setup hook for checking whether Tcl requires succeed
echo "Sourcing tcl-requires-check-hook.sh"

tclRequiresCheckPhase () {
    echo "Executing tclRequiresCheckPhase"

    if [ -n "$tclRequiresCheck" ]; then
        export TCLLIBPATH="$out/lib $TCLLIBPATH" # Redundant if tcl-package-hook is also used
        # FIXME: For some reason the output gets swallowed unless we pipe it through cat‽
        tclsh @tcl_hook@ 2>&1 | cat
    fi
}

if [ -z "${dontUseTclRequiresCheck-}" ]; then
    echo "Using tclRequiresCheckPhase"
    preDistPhases+=" tclRequiresCheckPhase"
fi
