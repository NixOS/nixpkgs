# Setup hook to use in case a maturin generated wheel should be unpacked
echo "Sourcing maturin setup hook"

wheelUnpackPhase(){
    echo "Executing maturinWheelUnpackPhase"
    runHook preUnpack

    mkdir -p dist
    cp "$src"/*.whl dist

#     runHook postUnpack # Calls find...?
    echo "Finished executing maturinWheelUnpackPhase"
}

if [ -z "${dontMaturinWheelUnpackPhase-}" ] && [ -z "${unpackPhase-}" ]; then
    echo "Using maturinWheelUnpackPhase"
    unpackPhase=maturinWheelUnpackPhase
fi
