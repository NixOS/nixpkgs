# Setup hook for detecting conflicts in Python packages
echo "Sourcing python-remove-bin-bytecode-hook.sh"

# Check if we have two packages with the same name in the closure and fail.
# If this happens, something went wrong with the dependencies specs.
# Intentionally kept in a subdirectory, see catch_conflicts/README.md.

pythonRemoveBinBytecodePhase () {
    if [ -d "$out/bin" ]; then
      rm -rf "$out/bin/__pycache__"                 # Python 3
      find "$out/bin" -type f -name "*.pyc" -delete # Python 2
    fi
}

if [ -z "$dontUsePythonRemoveBinBytecode" ]; then
    preDistPhases+=" pythonRemoveBinBytecodePhase"
fi
