# shellcheck shell=bash disable=SC2206

wafConfigurePhase() {
    runHook preConfigure

    if [ -f "${wafPath:=./waf}" ]; then
        patchShebangs --build "${wafPath}"
    else
        wafPath="@waf@/bin/waf"
    fi

    if [ -z "${dontAddPrefix:-}" ] && [ -n "$prefix" ]; then
        local prefixFlag="${prefixKey:---prefix=}$prefix"
    fi

    if [ -n "${PKG_CONFIG}" ]; then
      export PKGCONFIG="${PKG_CONFIG}"
    fi

    local flagsArray=( $prefixFlag )
    concatTo flagsArray wafConfigureFlags wafConfigureFlagsArray wafConfigureTargets=configure

    echoCmd 'waf configure flags' "${flagsArray[@]}"
    "$wafPath" "${flagsArray[@]}"

    if ! [[ -v enableParallelBuilding ]]; then
        enableParallelBuilding=1
        echo "waf: enabled parallel building"
    fi

    if ! [[ -v enableParallelInstalling ]]; then
        enableParallelInstalling=1
        echo "waf: enabled parallel installing"
    fi

    runHook postConfigure
}

wafBuildPhase () {
    runHook preBuild

    local flagsArray=( ${enableParallelBuilding:+-j ${NIX_BUILD_CORES}} )
    concatTo flagsArray wafFlags wafFlagsArray wafBuildFlags wafBuildFlagsArray wafBuildTargets=build

    echoCmd 'waf build flags' "${flagsArray[@]}"
    "$wafPath" "${flagsArray[@]}"

    runHook postBuild
}

wafInstallPhase() {
    runHook preInstall

    if [ -n "$prefix" ]; then
        mkdir -p "$prefix"
    fi

    local flagsArray=( ${enableParallelInstalling:+-j ${NIX_BUILD_CORES}} )
    concatTo flagsArray wafFlags wafFlagsArray wafInstallFlags wafInstallFlagsArray wafInstallTargets=install

    echoCmd 'waf install flags' "${flagsArray[@]}"
    "$wafPath" "${flagsArray[@]}"

    runHook postInstall
}

if [ -z "${dontUseWafConfigure-}" ] && [ -z "${configurePhase-}" ]; then
    configurePhase=wafConfigurePhase
fi

if [ -z "${dontUseWafBuild-}" ] && [ -z "${buildPhase-}" ]; then
    buildPhase=wafBuildPhase
fi

if [ -z "${dontUseWafInstall-}" ] && [ -z "${installPhase-}" ]; then
    installPhase=wafInstallPhase
fi
