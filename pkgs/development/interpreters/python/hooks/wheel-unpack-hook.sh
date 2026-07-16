# Setup hook to use in case a wheel is fetched
echo "Sourcing wheel setup hook"

wheelUnpackPhase() {
    echo "Executing wheelUnpackPhase"
    runHook preUnpack

    mkdir -p dist
    cp "$src" "dist/$(stripHash "$src")"

    # runHook postUnpack # Calls find...?
    echo "Finished executing wheelUnpackPhase"
}

if [ -z "${dontUseWheelUnpack-}" ] && [ -z "${unpackPhase-}" ]; then
    echo "Using wheelUnpackPhase"
    unpackPhase=wheelUnpackPhase
fi
