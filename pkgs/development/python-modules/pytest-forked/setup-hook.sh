pytestForkedHook() {
    pytestFlagsArray+=(
        "--forked"
    )

    # Using --forked on darwin leads to crashes when fork safety is
    # enabled. This often happens when urllib tries to request proxy
    # settings on MacOS through `urllib.request.getproxies()`
    # - https://github.com/python/cpython/issues/77906
    if [[ "$OSTYPE" == "darwin"* ]]; then
        export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES
    fi
}

# the flags should be added before pytestCheckHook runs so
# until we have dependency mechanism in generic builder, we need to use this ugly hack.

if [ -z "${dontUsePytestForked-}" ] && [ -z "${dontUsePytestCheck-}" ]; then
    if [[ " ${preDistPhases:-} " =~ " pytestCheckPhase " ]]; then
        preDistPhases+=" "
        preDistPhases="${preDistPhases/ pytestCheckPhase / pytestForkedHook pytestCheckPhase }"
    else
        preDistPhases+=" pytestForkedHook"
    fi
fi
