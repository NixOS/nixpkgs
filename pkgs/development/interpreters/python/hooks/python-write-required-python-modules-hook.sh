# Setup hook for writing the Python run-time dependencies to a nix-support file
echo "Sourcing python-write-required-python-modules-hook.sh"

pythonWriteRequiredPythonModulesPhase () {
    echo "Executing pythonWriteRequiredPythonModulesPhase"

    mkdir -p $out/nix-support
    echo ${requiredPythonModules-} > $out/nix-support/required-python-modules
}

# Yes its a bit long...
if [ -z "${dontUsePythonWriteRequiredPythonModulesPhase-}" ]; then
    echo "Using pythonWriteRequiredPythonModulesPhase"
    preDistPhases+=" pythonWriteRequiredPythonModulesPhase"
fi
