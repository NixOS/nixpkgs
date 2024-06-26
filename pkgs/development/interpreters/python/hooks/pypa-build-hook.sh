# Setup hook to use for pypa/build projects
echo "Sourcing pypa-build-hook"

pypaBuildPhase() {
    echo "Executing pypaBuildPhase"
    runHook preBuild

    echo "Creating a wheel..."
    @build@/bin/pyproject-build --no-isolation --outdir dist/ --wheel $pypaBuildFlags
    echo "Finished creating a wheel..."

    runHook postBuild
    echo "Finished executing pypaBuildPhase"
}

if [ -z "${dontUsePypaBuild-}" ] && [ -z "${buildPhase-}" ]; then
    echo "Using pypaBuildPhase"
    buildPhase=pypaBuildPhase
fi
