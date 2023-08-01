# shellcheck shell=bash disable=SC2154,SC2086

# This readonly zigDefaultBuildFlagsArray below is meant to avoid CPU feature
# impurity in Nixpkgs. However, this flagset is "unstable": it is specifically
# meant to be controlled by the upstream development team - being up to that
# team exposing or not that flags to the outside (especially the package manager
# teams).

# Because of this hurdle, @andrewrk from Zig Software Foundation proposed some
# solutions for this issue. Hopefully they will be implemented in future
# releases of Zig. When this happens, this flagset should be revisited
# accordingly.

# Below are some useful links describing the discovery process of this 'bug' in
# Nixpkgs:

# https://github.com/NixOS/nixpkgs/issues/169461
# https://github.com/NixOS/nixpkgs/issues/185644
# https://github.com/NixOS/nixpkgs/pull/197046
# https://github.com/NixOS/nixpkgs/pull/241741#issuecomment-1624227485
# https://github.com/ziglang/zig/issues/14281#issuecomment-1624220653

readonly zigDefaultFlagsArray=("-Drelease-safe=true" "-Dcpu=baseline")

function zigSetGlobalCacheDir {
    ZIG_GLOBAL_CACHE_DIR=$(mktemp -d)
    export ZIG_GLOBAL_CACHE_DIR
}

function zigBuildPhase {
    runHook preBuild

    local flagsArray=(
        "${zigDefaultFlagsArray[@]}"
        $zigBuildFlags "${zigBuildFlagsArray[@]}"
    )

    echoCmd 'build flags' "${flagsArray[@]}"
    zig build "${flagsArray[@]}"

    runHook postBuild
}

function zigCheckPhase {
    runHook preCheck

    local flagsArray=(
        "${zigDefaultFlagsArray[@]}"
        $zigCheckFlags "${zigCheckFlagsArray[@]}"
    )

    echoCmd 'check flags' "${flagsArray[@]}"
    zig build test "${flagsArray[@]}"

    runHook postCheck
}

function zigInstallPhase {
    runHook preInstall

    local flagsArray=(
        "${zigDefaultFlagsArray[@]}"
        $zigBuildFlags "${zigBuildFlagsArray[@]}"
        $zigInstallFlags "${zigInstallFlagsArray[@]}"
    )

    if [ -z "${dontAddPrefix-}" ]; then
        # Zig does not recognize `--prefix=/dir/`, only `--prefix /dir/`
        flagsArray+=("${prefixKey:---prefix}" "$prefix")
    fi

    echoCmd 'install flags' "${flagsArray[@]}"
    zig build install "${flagsArray[@]}"

    runHook postInstall
}

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
