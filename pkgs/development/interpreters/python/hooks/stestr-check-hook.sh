# Setup hook for stestr.
# shellcheck shell=bash

echo "Sourcing stestr-check-hook"

stestrCheckPhase() {
    echo "Executing stestrCheckPhase"
    runHook preCheck

    @pythonCheckInterpreter@ -m stestr run

    runHook postCheck
    echo "Finished executing stestrCheckPhase"
}

if [[ -z "${dontUseStestrCheck-}" ]] && [[ -z "${installCheckPhase-}" ]]; then
    echo "Using stestrCheckPhase"
    appendToVar preDistPhases stestrCheckPhase
fi
