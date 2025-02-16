# Setup hook to use for pypa/build projects
# shellcheck shell=bash

echo "Sourcing pypa-build-hook"

pypaBuildPhase() {
    echo "Executing pypaBuildPhase"
    runHook preBuild

    local -a flagsArray=(
        --no-isolation
        --outdir dist/
        --wheel
    )
    concatTo flagsArray pypaBuildFlags

    echo "Creating a wheel..."
    echoCmd 'pypa build flags' "${flagsArray[@]}"
    @build@/bin/pyproject-build "${flagsArray[@]}"
    echo "Finished creating a wheel..."

    runHook postBuild
    echo "Finished executing pypaBuildPhase"
}

if [ -z "${dontUsePypaBuild-}" ] && [ -z "${buildPhase-}" ]; then
    echo "Using pypaBuildPhase"
    buildPhase=pypaBuildPhase
fi
