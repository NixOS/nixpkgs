# shellcheck shell=bash disable=SC2206

wafConfigurePhase() {
    runHook preConfigure

    if ! [ -f "${wafPath:=./waf}" ]; then
        echo "copying waf to $wafPath..."
        cp @waf@/bin/waf "$wafPath"
    fi

    if [ -z "${dontAddPrefix:-}" ] && [ -n "$prefix" ]; then
        local prefixFlag="${prefixKey:---prefix=}$prefix"
    fi

    if [ -n "${PKG_CONFIG}" ]; then
      export PKGCONFIG="${PKG_CONFIG}"
    fi

    local flagsArray=(
        $prefixFlag
        $wafConfigureFlags "${wafConfigureFlagsArray[@]}"
        ${wafConfigureTargets:-configure}
    )

    echoCmd 'waf configure flags' "${flagsArray[@]}"
    python "$wafPath" "${flagsArray[@]}"

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

    # set to empty if unset
    : "${wafFlags=}"

    local flagsArray=(
      ${enableParallelBuilding:+-j ${NIX_BUILD_CORES}}
      $wafFlags ${wafFlagsArray[@]}
      $wafBuildFlags ${wafBuildFlagsArray[@]}
      ${wafBuildTargets:-build}
    )

    echoCmd 'waf build flags' "${flagsArray[@]}"
    python "$wafPath" "${flagsArray[@]}"

    runHook postBuild
}

wafInstallPhase() {
    runHook preInstall

    if [ -n "$prefix" ]; then
        mkdir -p "$prefix"
    fi

    local flagsArray=(
        ${enableParallelInstalling:+-j ${NIX_BUILD_CORES}}
        $wafFlags ${wafFlagsArray[@]}
        $wafInstallFlags ${wafInstallFlagsArray[@]}
        ${wafInstallTargets:-install}
    )

    echoCmd 'waf install flags' "${flagsArray[@]}"
    python "$wafPath" "${flagsArray[@]}"

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
