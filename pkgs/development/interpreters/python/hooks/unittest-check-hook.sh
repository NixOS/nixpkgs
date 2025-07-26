# Setup hook for unittest.
# shellcheck shell=bash

echo "Sourcing unittest-check-hook"

unittestCheckPhase() {
    echo "Executing unittestCheckPhase"
    runHook preInstallCheck

    local -a flagsArray=()

    # Compatibility layer to the obsolete unittestFlagsArray
    eval "flagsArray+=(${unittestFlagsArray[*]-})"

    concatTo flagsArray unittestFlags
    echoCmd 'unittest flags' "${flagsArray[@]}"
    @pythonCheckInterpreter@ -m unittest discover "${flagsArray[@]}"

    runHook postInstallCheck
    echo "Finished executing unittestCheckPhase"
}

if [[ -z "${dontUseUnittestCheck-}" ]] && [[ -z "${installCheckPhase-}" ]]; then
    echo "Using unittestCheckPhase"
    installCheckPhase=unittestCheckPhase
fi
