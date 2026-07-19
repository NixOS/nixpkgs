# Setup hook for recompiling bytecode.
# https://github.com/NixOS/nixpkgs/issues/81441
echo "Sourcing python-recompile-bytecode-hook.sh"

# Remove all bytecode from the $out output. Then, recompile only site packages folder
# Note this effectively duplicates `python-remove-bin-bytecode`, but long-term
# this hook should be removed again.

pythonRecompileBytecodePhase() {
    # TODO: consider other outputs than $out

    items="$(find "$out" -name "@bytecodeName@")"
    if [[ -n $items ]]; then
        for pycache in $items; do
            rm -rf "$pycache"
        done
    fi

    # Skip metadata directories: some packages ship .py files inside their
    # dist-info, and compiling those embeds the store path in the metadata.
    find "$out"/@pythonSitePackages@ \( -name '*.dist-info' -o -name '*.egg-info' \) -prune -o -name '*.py' -exec @pythonInterpreter@ -OO -m compileall @compileArgs@ {} +
}

if [ -z "${dontUsePythonRecompileBytecode-}" ]; then
    appendToVar postPhases pythonRecompileBytecodePhase
fi
