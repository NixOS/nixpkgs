# Setup hook to use in case an egg is fetched
echo "Sourcing egg setup hook"

eggUnpackPhase(){
    echo "Executing eggUnpackPhase"
    runHook preUnpack

    cp "$src" "$(stripHash "$src")"

#     runHook postUnpack # Calls find...?
    echo "Finished executing eggUnpackPhase"
}

if [ -z "${dontUseEggUnpack-}" ] && [ -z "${unpackPhase-}" ]; then
    echo "Using eggUnpackPhase"
    unpackPhase=eggUnpackPhase
fi
