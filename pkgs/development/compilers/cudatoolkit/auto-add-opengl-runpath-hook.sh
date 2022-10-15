# Run autoOpenGLRunpath on all files
echo "Sourcing auto-add-opengl-runpath-hook"

autoAddOpenGLRunpathPhase  () {
    # TODO: support multiple outputs
    for file in $(find ${out,lib,bin} -type f); do
        addHardwareRunpath $file
    done
}

if [ -z "${dontUseAutoAddOpenGLRunpath-}" ]; then
    echo "Using autoAddOpenGLRunpathPhase"
    postFixupHooks+=(autoAddOpenGLRunpathPhase)
fi
