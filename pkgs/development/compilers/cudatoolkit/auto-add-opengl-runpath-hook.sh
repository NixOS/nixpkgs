#!/usr/bin/env bash

# Run autoOpenGLRunpath on all files
echo "Sourcing auto-add-opengl-runpath-hook"

autoAddOpenGLRunpathPhase() {
    # shellcheck disable=SC2154 # ignore undeclared "outputs"
    # shellcheck disable=SC2068 # ignore "double quote array expansions" for ${outputs[@]}
    # FIXME: SC2044 (warning): For loops over find output are fragile. Use find -exec or a while read loop
    for file in $(
        find $(
            for output in ${outputs[@]} ; do
                [ -e ${!output} ] || continue
                echo ${!output}
            done
        ) -type f
    ); do
        addOpenGLRunpath $file
    done
}

if [ -z "${dontUseAutoAddOpenGLRunpath-}" ]; then
    echo "Using autoAddOpenGLRunpathPhase"
    postFixupHooks+=(autoAddOpenGLRunpathPhase)
fi
