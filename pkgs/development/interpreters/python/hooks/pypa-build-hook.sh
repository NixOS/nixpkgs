# Setup hook to use for pypa/build projects
echo "Sourcing pypa-build-hook"

pypaBuildPhase() {
    echo "Executing pypaBuildPhase"
    runHook preBuild

    # ShellCheck seems unable to parse nameref used to implement concatTo.
    # shellcheck disable=2034
    declare -a defaultPypaBuildFlags=(
        --no-isolation
        --outdir dist/
        --wheel
    )

    local -a flagsArray=()
    concatTo flagsArray defaultPypaBuildFlags pypaBuildFlags

    echo "Creating a wheel..."
    # shellcheck disable=2154
    @build@/bin/pyproject-build "${flagsArray[@]}"
    echo "Finished creating a wheel..."

    unset flagsArray

    runHook postBuild
    echo "Finished executing pypaBuildPhase"
}

if [ -z "${dontUsePypaBuild-}" ] && [ -z "${buildPhase-}" ]; then
    echo "Using pypaBuildPhase"
    buildPhase=pypaBuildPhase
fi
