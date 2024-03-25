# Setup hook for setuptools.
echo "Sourcing setuptools-build-hook"

setuptoolsBuildPhase() {
    echo "Executing setuptoolsBuildPhase"
    local args
    runHook preBuild

    cp -f @setuppy@ nix_run_setup
    args=""
    if [ -n "$setupPyGlobalFlags" ]; then
        args+="$setupPyGlobalFlags"
    fi
    if [ -n "$enableParallelBuilding" ]; then
        setupPyBuildFlags+=" --parallel $NIX_BUILD_CORES"
    fi
    if [ -n "$setupPyBuildFlags" ]; then
        args+=" build_ext $setupPyBuildFlags"
    fi
    eval "@pythonInterpreter@ nix_run_setup $args bdist_wheel"

    runHook postBuild
    echo "Finished executing setuptoolsBuildPhase"
}

if [ -z "${dontUseSetuptoolsBuild-}" ] && [ -z "${buildPhase-}" ]; then
    echo "Using setuptoolsBuildPhase"
    buildPhase=setuptoolsBuildPhase
fi
