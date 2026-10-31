# shellcheck shell=bash

# xtool looks for the SDK in SwiftPM's config directory
xtoolSetupSdk() {
    export XDG_CONFIG_HOME="$NIX_BUILD_TOP/.config"
    mkdir -p "$XDG_CONFIG_HOME/swiftpm/swift-sdks"
    ln -s @sdk@ "$XDG_CONFIG_HOME/swiftpm/swift-sdks/darwin.artifactbundle"
}

postHooks+=(xtoolSetupSdk)

xtoolBuildPhase() {
    runHook preBuild

    local flagsArray=(
        --configuration "${xtoolBuildConfig-release}"
    )
    concatTo flagsArray xtoolBuildFlags xtoolBuildFlagsArray

    echoCmd 'xtool build flags' "${flagsArray[@]}"
    xtool dev build "${flagsArray[@]}"

    runHook postBuild
}

if [ -z "${dontUseXtoolBuild-}" ] && [ -z "${buildPhase-}" ]; then
    buildPhase=xtoolBuildPhase
fi

xtoolInstallPhase() {
    runHook preInstall

    local bundle bundles=()
    for bundle in xtool/*.app xtool/*.ipa; do
        [ -e "$bundle" ] && bundles+=("$bundle")
    done
    if [ ${#bundles[@]} -eq 0 ]; then
        echo "xtoolInstallPhase: no .app or .ipa in xtool/" >&2
        exit 1
    fi

    # shellcheck disable=SC2154
    mkdir -p "$out"
    cp -R "${bundles[@]}" "$out/"

    runHook postInstall
}

if [ -z "${dontUseXtoolInstall-}" ] && [ -z "${installPhase-}" ]; then
    installPhase=xtoolInstallPhase
fi
