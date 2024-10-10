# Setup hook for unittest.
# shellcheck shell=bash

echo "Sourcing unittest-check-hook"

# shellcheck source=pkgs/development/interpreters/python/compat-helpers.sh
source @compatHelpers@

expandStringAndConvertToArray unittestFlagsArray

unittestCheckPhase() {
    echo "Executing unittestCheckPhase"
    runHook preCheck

    # shellcheck disable=SC2154
    @pythonCheckInterpreter@ -m unittest discover "${unittestFlagsArray[@]}"

    runHook postCheck
    echo "Finished executing unittestCheckPhase"
}

if [[ -z "${dontUseUnittestCheck-}" ]] && [[ -z "${installCheckPhase-}" ]]; then
    echo "Using unittestCheckPhase"
    appendToVar preDistPhases unittestCheckPhase
fi
