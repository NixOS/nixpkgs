# Setup hook for removing bytecode from the bin folder
echo "Sourcing python-remove-bin-bytecode-hook.sh"

# The bin folder is added to $PATH and should only contain executables.
# It may happen there are executables with a .py extension for which
# bytecode is generated. This hook removes that bytecode.

pythonRemoveBinBytecodePhase () {
    if [ -d "$out/bin" ]; then
      rm -rf "$out/bin/__pycache__"                 # Python 3
      find "$out/bin" -type f -name "*.pyc" -delete # Python 2
    fi
}

if [ -z "${dontUsePythonRemoveBinBytecode-}" ]; then
    preDistPhases+=" pythonRemoveBinBytecodePhase"
fi
