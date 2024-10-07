# Setup hook for unittest.
echo "Sourcing unittest-check-hook"

# shellcheck source=pkgs/development/interpreters/python/compat-helpers.sh
source @compatHelpers@

canonicalizeFlagsArrayExpandString unittestFlagsArray

unittestCheckPhase() {
    echo "Executing unittestCheckPhase"
    runHook preCheck

    @pythonCheckInterpreter@ -m unittest discover "${unittestFlagsArray[@]}"

    runHook postCheck
    echo "Finished executing unittestCheckPhase"
}

if [ -z "${dontUseUnittestCheck-}" ] && [ -z "${installCheckPhase-}" ]; then
    echo "Using unittestCheckPhase"
    appendToVar preDistPhases unittestCheckPhase
fi
