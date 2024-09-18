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
    zig build "${flagsArray[@]}"

    runHook postBuild
}

function zigCheckPhase {
    runHook preCheck

    local flagsArray=()
    concatTo flagsArray zigDefaultFlagsArray \
        zigCheckFlags zigCheckFlagsArray

    echoCmd 'zig check flags' "${flagsArray[@]}"
    zig build test "${flagsArray[@]}"

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
    zig build install "${flagsArray[@]}"

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
