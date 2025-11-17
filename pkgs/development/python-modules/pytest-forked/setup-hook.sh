pytestForkedHook() {
    appendToVar pytestFlags "--forked"

    # Using --forked on darwin leads to crashes when fork safety is
    # enabled. This often happens when urllib tries to request proxy
    # settings on MacOS through `urllib.request.getproxies()`
    # - https://github.com/python/cpython/issues/77906
    if [[ "$OSTYPE" == "darwin"* ]]; then
        export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES
    fi
}

if [ -z "${dontUsePytestForked-}" ] && [ -z "${dontUsePytestCheck-}" ]; then
    # The flags should be added before pytestCheckHook runs in preDistPhases.
    postInstallCheckHooks+=(pytestForkedHook)
fi
