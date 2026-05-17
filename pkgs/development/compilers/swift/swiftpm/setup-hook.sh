# shellcheck shell=bash

# Build using 'swift-build'.
swiftpmBuildPhase() {
    runHook preBuild

    local buildCores=1
    if [ "${enableParallelBuilding-1}" ]; then
        buildCores="$NIX_BUILD_CORES"
    fi

    local flagsArray=(
        -j "$buildCores"
        -c "${swiftpmBuildConfig-release}"
    )
    concatTo flagsArray swiftpmFlags swiftpmFlagsArray

    echoCmd 'build flags' "${flagsArray[@]}"
    TERM=dumb swift-build "${flagsArray[@]}"

    runHook postBuild
}

if [ -z "${dontUseSwiftpmBuild-}" ] && [ -z "${buildPhase-}" ]; then
    buildPhase=swiftpmBuildPhase
fi

# Check using 'swift-test'.
swiftpmCheckPhase() {
    runHook preCheck

    local buildCores=1
    if [ "${enableParallelBuilding-1}" ]; then
        buildCores="$NIX_BUILD_CORES"
    fi

    local flagsArray=(
        -j "$buildCores"
        -c "${swiftpmBuildConfig-release}"
    )
    concatTo flagsArray swiftpmFlags swiftpmFlagsArray

    echoCmd 'check flags' "${flagsArray[@]}"
    TERM=dumb swift-test "${flagsArray[@]}"

    runHook postCheck
}

if [ -z "${dontUseSwiftpmCheck-}" ] && [ -z "${checkPhase-}" ]; then
    checkPhase=swiftpmCheckPhase
fi

# Helper used to find the binary output path.
# Useful for performing the installPhase of swiftpm packages.
swiftpmBinPath() {
    local flagsArray=(
        -c "${swiftpmBuildConfig-release}"
    )
    concatTo flagsArray swiftpmFlags swiftpmFlagsArray

    swift-build --show-bin-path "${flagsArray[@]}"
}
