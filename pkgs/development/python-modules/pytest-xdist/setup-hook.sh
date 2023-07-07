pytestXdistHook() {
    pytestFlagsArray+=(
        "--numprocesses=$NIX_BUILD_CORES"
    )
}

# the flags should be added before pytestCheckHook runs so
# until we have dependency mechanism in generic builder, we need to use this ugly hack.

if [ -z "${dontUsePytestXdist-}" ] && [ -z "${dontUsePytestCheck-}" ]; then
    if [[ " ${preDistPhases:-} " =~ " pytestCheckPhase " ]]; then
        preDistPhases+=" "
        preDistPhases="${preDistPhases/ pytestCheckPhase / pytestXdistHook pytestCheckPhase }"
    else
        preDistPhases+=" pytestXdistHook"
    fi
fi
