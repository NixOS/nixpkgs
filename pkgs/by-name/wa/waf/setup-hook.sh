# shellcheck shell=bash disable=SC2206

wafConfigurePhase() {
    runHook preConfigure

    if ! [ -f "${wafPath:=./waf}" ]; then
        nixInfoLog "${FUNCNAME[0]}: copying waf to $wafPath..."
        cp @waf@/bin/waf "$wafPath"
    fi

    if [ -z "${dontAddPrefix:-}" ] && [ -n "$prefix" ]; then
        local prefixFlag="${prefixKey:---prefix=}$prefix"
    fi

    if [ -n "${PKG_CONFIG}" ]; then
      export PKGCONFIG="${PKG_CONFIG}"
    fi

    local flagsArray=( $prefixFlag )
    concatTo flagsArray wafConfigureFlags wafConfigureFlagsArray wafConfigureTargets=configure

    nixInfoLog "${FUNCNAME[0]}: configure flags: ${flagsArray[@]}"
    python "$wafPath" "${flagsArray[@]}"

    if ! [[ -v enableParallelBuilding ]]; then
        enableParallelBuilding=1
        nixInfoLog "${FUNCNAME[0]}: enabled parallel building"
    fi

    if ! [[ -v enableParallelInstalling ]]; then
        enableParallelInstalling=1
        nixInfoLog "${FUNCNAME[0]}: enabled parallel installing"
    fi

    runHook postConfigure
}

wafBuildPhase () {
    runHook preBuild

    local flagsArray=( ${enableParallelBuilding:+-j ${NIX_BUILD_CORES}} )
    concatTo flagsArray wafFlags wafFlagsArray wafBuildFlags wafBuildFlagsArray wafBuildTargets=build

    nixInfoLog "${FUNCNAME[0]}: build flags: ${flagsArray[@]}"
    python "$wafPath" "${flagsArray[@]}"

    runHook postBuild
}

wafInstallPhase() {
    runHook preInstall

    if [ -n "$prefix" ]; then
        mkdir -p "$prefix"
    fi

    local flagsArray=( ${enableParallelInstalling:+-j ${NIX_BUILD_CORES}} )
    concatTo flagsArray wafFlags wafFlagsArray wafInstallFlags wafInstallFlagsArray wafInstallTargets=install

    nixInfoLog "${FUNCNAME[0]}: install flags: ${flagsArray[@]}"
    python "$wafPath" "${flagsArray[@]}"

    runHook postInstall
}

if [ -z "${dontUseWafConfigure-}" ] && [ -z "${configurePhase-}" ]; then
    configurePhase=wafConfigurePhase
    nixInfoLog "${FUNCNAME[0]}: set configurePhase to wafConfigurePhase"
fi

if [ -z "${dontUseWafBuild-}" ] && [ -z "${buildPhase-}" ]; then
    buildPhase=wafBuildPhase
    nixInfoLog "${FUNCNAME[0]}: set buildPhase to wafBuildPhase"
fi

if [ -z "${dontUseWafInstall-}" ] && [ -z "${installPhase-}" ]; then
    installPhase=wafInstallPhase
    nixInfoLog "${FUNCNAME[0]}: set installPhase to wafInstallPhase"
fi
