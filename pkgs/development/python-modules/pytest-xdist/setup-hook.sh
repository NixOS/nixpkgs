pytestXdistHook() {
    pytestFlagsArray+=(
        "--numprocesses=$NIX_BUILD_CORES"
        "--forked"
    )
}

if [ -z "${dontUsePytestXdist-}" ] && [ -z "${dontUsePytestCheck-}" ]; then
    preDistPhases+=" pytestXdistHook"
fi
