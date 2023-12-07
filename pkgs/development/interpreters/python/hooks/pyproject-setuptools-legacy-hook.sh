pyprojectSetuptoolsLegacyFlagsHook() {
    echo "Executing pyprojectSetuptoolsLegacyFlagsHook"

    if [ -n "$setupPyGlobalFlags" ]; then
        for f in $setupPyGlobalFlags; do
            pypaBuildFlags+=" --config-setting=--global-option=$f"
        done
    fi

    if [ -n "$setupPyBuildFlags" ]; then
        for f in $setupPyBuildFlags; do
            pypaBuildFlags+=" --config-setting=--build-option=$f"
        done
    fi
}

pyprojectSetuptoolsLegacyPatchHook() {
    echo "Executing setuptoolsPyprojectLegacyPatchHook"

    if ! test -f pyproject.toml; then
        return
    fi

    @pythonInterpreter@ @patchScript@
}

postPatchHooks+=(pyprojectSetuptoolsLegacyPatchHook)
preConfigureHooks+=(pyprojectSetuptoolsLegacyFlagsHook)
