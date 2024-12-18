# Setup hook for unittest.
echo "Sourcing unittest-check-hook"

unittestCheckPhase() {
    echo "Executing unittestCheckPhase"
    runHook preCheck

    export HOME=$(mktemp -d)

    # If the path $out/bin exists, add it to the PATH environment variable
    if [ -d "$out/bin" ]; then
        export PATH="$out/bin${PATH:+:}$PATH"
    fi

    eval "@pythonCheckInterpreter@ -m unittest discover $unittestFlagsArray"

    runHook postCheck
    echo "Finished executing unittestCheckPhase"
}

if [ -z "${dontUseUnittestCheck-}" ] && [ -z "${installCheckPhase-}" ]; then
    echo "Using unittestCheckPhase"
    appendToVar preDistPhases unittestCheckPhase
fi
