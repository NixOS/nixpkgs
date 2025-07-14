# shellcheck shell=bash

# shellcheck disable=SC2034
readonly zigDefaultFlagsArray=(@zig_default_flags@)

function zigSetGlobalCacheDir {
    ZIG_GLOBAL_CACHE_DIR=$(mktemp -d)
    export ZIG_GLOBAL_CACHE_DIR
}

function zigBuildPhase {
    runHook preBuild

    local flagsArray=()
    concatTo flagsArray zigDefaultFlagsArray \
        zigBuildFlags zigBuildFlagsArray

    echoCmd 'zig build flags' "${flagsArray[@]}"
    TERM=dumb zig build "${flagsArray[@]}" --verbose

    runHook postBuild
}

function zigCheckPhase {
    runHook preCheck

    local flagsArray=()
    concatTo flagsArray zigDefaultFlagsArray \
        zigCheckFlags zigCheckFlagsArray

    echoCmd 'zig check flags' "${flagsArray[@]}"
    TERM=dumb zig build test "${flagsArray[@]}" --verbose

    runHook postCheck
}

function zigInstallPhase {
    runHook preInstall

    local flagsArray=()
    concatTo flagsArray zigDefaultFlagsArray \
        zigBuildFlags zigBuildFlagsArray \
        zigInstallFlags zigInstallFlagsArray

    if [ -z "${dontAddPrefix-}" ]; then
        # Zig does not recognize `--prefix=/dir/`, only `--prefix /dir/`
        flagsArray+=("${prefixKey:---prefix}" "$prefix")
    fi

    echoCmd 'zig install flags' "${flagsArray[@]}"
    TERM=dumb zig build install "${flagsArray[@]}" --verbose

    runHook postInstall
}

# shellcheck disable=SC2154
addEnvHooks "$targetOffset" zigSetGlobalCacheDir

if [ -z "${dontUseZigBuild-}" ] && [ -z "${buildPhase-}" ]; then
    buildPhase=zigBuildPhase
fi

if [ -z "${dontUseZigCheck-}" ] && [ -z "${checkPhase-}" ]; then
    checkPhase=zigCheckPhase
fi

if [ -z "${dontUseZigInstall-}" ] && [ -z "${installPhase-}" ]; then
    installPhase=zigInstallPhase
fi
