pytestXdistHook() {
    pytestFlagsArray+=("--numprocesses=$NIX_BUILD_CORES" "--forked" )
}

if [ -z "${dontUsePytestXdist-}" ] && [ -z "${dontUsePytestCheck-}" ]; then
    addEnvHooks "$hostOffset" pytestXdistHook
fi
