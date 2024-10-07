# Setup hook for setuptools.
echo "Sourcing setuptools-build-hook"

# shellcheck source=pkgs/development/interpreters/python/compat-helpers.sh
source @compatHelpers@

setuptoolsBuildPhase() {
    echo "Executing setuptoolsBuildPhase"
    local setuptools_has_parallel=@setuptools_has_parallel@
    runHook preBuild

    cp -f @setuppy@ nix_run_setup
    local -a flagsArray=()
    if [ -n "${setupPyGlobalFlags[*]-}" ]; then
        expandStringAndConcatTo flagsArray setupPyGlobalFlags
    fi
    if [ -n "$enableParallelBuilding" ]; then
        if [ -n "$setuptools_has_parallel" ]; then
            appendToVar setupPyBuildFlags --parallel "$NIX_BUILD_CORES"
        fi
    fi
    if [ -n "${setupPyBuildFlags[*]-}" ]; then
        flagsArray+=(build_ext)
        expandStringAndConcatTo flagsArray setupPyBuildFlags
    fi
    @pythonInterpreter@ nix_run_setup "${flagsArray[@]}" bdist_wheel

    runHook postBuild
    echo "Finished executing setuptoolsBuildPhase"
}

if [ -z "${dontUseSetuptoolsBuild-}" ] && [ -z "${buildPhase-}" ]; then
    echo "Using setuptoolsBuildPhase"
    buildPhase=setuptoolsBuildPhase
fi
