# shellcheck shell=bash

# shellcheck disable=SC2034
readonly zigDefaultCpuFlag=@zig_default_cpu_flag@
readonly zigDefaultOptimizeFlag=@zig_default_optimize_flag@

function zigConfigureHook {
  ZIG_GLOBAL_CACHE_DIR=$(mktemp -d)
  export ZIG_GLOBAL_CACHE_DIR
}

function zigConfigurePhase {
  runHook preConfigure

  zigConfigureHook

  runHook postConfigure
}

function zigBuildHook {
  local buildCores=1

  # Parallel building is enabled by default.
  if [ "${enableParallelBuilding-1}" ]; then
    buildCores="$NIX_BUILD_CORES"
  fi

  local flagsArray=(
    "-j$buildCores"
  )
  concatTo flagsArray \
    zigBuildFlags zigBuildFlagsArray

  if [ -z "${dontSetZigDefaultFlags:-}" ]; then
    concatTo flagsArray \
      zigDefaultCpuFlag zigDefaultOptimizeFlag
  fi

  echoCmd 'zig build flags' "${flagsArray[@]}"
  TERM=dumb zig build "${flagsArray[@]}" --verbose
}

function zigBuildPhase {
  runHook preBuild

  zigBuildHook

  runHook postBuild
}

function zigCheckHook {
  local buildCores=1

  # Parallel building is enabled by default.
  if [ "${enableParallelChecking-1}" ]; then
    buildCores="$NIX_BUILD_CORES"
  fi

  local flagsArray=(
    "-j$buildCores"
  )
  concatTo flagsArray \
    zigCheckFlags zigCheckFlagsArray

  if [ -z "${dontSetZigDefaultFlags:-}" ]; then
    concatTo flagsArray \
      zigDefaultCpuFlag zigDefaultOptimizeFlag
  fi

  echoCmd 'zig check flags' "${flagsArray[@]}"
  TERM=dumb zig build test "${flagsArray[@]}" --verbose
}

function zigCheckPhase {
  runHook preCheck

  zigCheckHook

  runHook postCheck
}

function zigInstallHook {
  local buildCores=1

  # Parallel building is enabled by default.
  if [ "${enableParallelInstalling-1}" ]; then
    buildCores="$NIX_BUILD_CORES"
  fi

  local flagsArray=(
    "-j$buildCores"
  )

  concatTo flagsArray \
    zigBuildFlags zigBuildFlagsArray \
    zigInstallFlags zigInstallFlagsArray

  if [ -z "${dontSetZigDefaultFlags:-}" ]; then
    concatTo flagsArray \
      zigDefaultCpuFlag zigDefaultOptimizeFlag
  fi

  if [ -z "${dontAddPrefix-}" ] && [ -n "$prefix" ]; then
    # Zig does not recognize `--prefix=/dir/`, only `--prefix /dir/`
    flagsArray+=("${prefixKey:---prefix}" "$prefix")
  fi

  echoCmd 'zig install flags' "${flagsArray[@]}"
  TERM=dumb zig build install "${flagsArray[@]}" --verbose

}

function zigInstallPhase {
  runHook preInstall

  zigInstallHook

  runHook postInstall
}

if [ -z "${dontUseZigConfigure-}" ]; then
    if [ -z "${configurePhase-}" ]; then
        configurePhase=zigConfigurePhase
    else
        preConfigureHooks+=(zigConfigureHook)
    fi
fi

if [ -z "${dontUseZigBuild-}" ]; then
    if [ -z "${buildPhase-}" ]; then
        buildPhase=zigBuildPhase
    else
        preBuildHooks+=(zigBuildHook)
    fi
fi

if [ -z "${dontUseZigCheck-}" ]; then
    if [ -z "${checkPhase-}" ]; then
        checkPhase=zigCheckPhase
    else
        preCheckHooks+=(zigCheckHook)
    fi
fi

if [ -z "${dontUseZigInstall-}" ]; then
    if [ -z "${installPhase-}" ]; then
        installPhase=zigInstallPhase
    else
        preInstallHooks+=(zigInstallHook)
    fi
fi
