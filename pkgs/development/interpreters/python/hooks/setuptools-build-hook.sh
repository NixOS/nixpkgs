# Setup hook for setuptools.
# shellcheck shell=bash

echo "Sourcing setuptools-build-hook"

setuptoolsBuildPhase() {
    echo "Executing setuptoolsBuildPhase"
    local setuptools_has_parallel=@setuptools_has_parallel@
    runHook preBuild

    cp -f @setuppy@ nix_run_setup
    local -a flagsArray=()
    if [ -n "${setupPyGlobalFlags[*]-}" ]; then
        concatTo flagsArray setupPyGlobalFlags
    fi
    if [ -n "$enableParallelBuilding" ]; then
        if [ -n "$setuptools_has_parallel" ]; then
            appendToVar setupPyBuildFlags --parallel "$NIX_BUILD_CORES"
        fi
    fi
    if [ -n "${setupPyBuildFlags[*]-}" ]; then
        flagsArray+=(build_ext)
        concatTo flagsArray setupPyBuildFlags
    fi
    echoCmd 'setup.py build flags' "${flagsArray[@]}"
    @pythonInterpreter@ nix_run_setup "${flagsArray[@]}" bdist_wheel

    runHook postBuild
    echo "Finished executing setuptoolsBuildPhase"
}

if [ -z "${dontUseSetuptoolsBuild-}" ] && [ -z "${buildPhase-}" ]; then
    echo "Using setuptoolsBuildPhase"
    buildPhase=setuptoolsBuildPhase
fi
