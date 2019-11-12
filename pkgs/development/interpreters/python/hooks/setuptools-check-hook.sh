# Setup hook for setuptools.
echo "Sourcing setuptools-check-hook"

setuptoolsCheckPhase() {
    echo "Executing setuptoolsCheckPhase"
    runHook preCheck

    cp -f @setuppy@ nix_run_setup
    @pythonCheckInterpreter@ nix_run_setup test

    runHook postCheck
    echo "Finished executing setuptoolsCheckPhase"
}

if [ -z "${dontUseSetuptoolsCheck-}" ] && [ -z "${installCheckPhase-}" ]; then
    echo "Using setuptoolsCheckPhase"
    preDistPhases+=" setuptoolsCheckPhase"
fi
