# Setup hook for setuptools.
echo "Sourcing setuptools-build-hook"

setuptoolsBuildPhase() {
    echo "Executing setuptoolsBuildPhase"
    local args setuptools_has_parallel=@setuptools_has_parallel@
    runHook preBuild

    cp -f @setuppy@ nix_run_setup
    args=""
    if [ -n "$setupPyGlobalFlags" ]; then
        args+="$setupPyGlobalFlags"
    fi
    if [ -n "$enableParallelBuilding" ]; then
        if [ -n "$setuptools_has_parallel" ]; then
            setupPyBuildFlags+=" --parallel $NIX_BUILD_CORES"
        fi
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
