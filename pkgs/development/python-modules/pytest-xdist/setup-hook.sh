pytestXdistHook() {
    appendToVar pytestFlags "--numprocesses=$NIX_BUILD_CORES"
}

if [ -z "${dontUsePytestXdist-}" ] && [ -z "${dontUsePytestCheck-}" ]; then
    # The flags should be added before pytestCheckHook runs in preDistPhases.
    preInstallCheckHooks+=(pytestXdistHook)
fi
