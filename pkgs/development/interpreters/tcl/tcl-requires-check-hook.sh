# Setup hook for checking whether Tcl requires succeed
echo "Sourcing tcl-requires-check-hook.sh"

tclRequiresCheckPhase () {
    echo "Executing tclRequiresCheckPhase"

    if [ -n "$tclRequiresCheck" ]; then
        echo "Check whether the following packages can be required: $tclRequiresCheck"
        export TCLLIBPATH="$out/lib $TCLLIBPATH" # Redundant if tcl-package-hook is also used
        tclsh <<<'exit [catch {foreach req $env(tclRequiresCheck) {package require $req}}]'
    fi
}

if [ -z "${dontUseTclRequiresCheck-}" ]; then
    echo "Using tclRequiresCheckPhase"
    preDistPhases+=" tclRequiresCheckPhase"
fi
