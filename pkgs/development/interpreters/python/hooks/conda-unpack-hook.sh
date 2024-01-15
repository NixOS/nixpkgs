# Setup hook to use in case a conda binary package is fetched
echo "Sourcing conda unpack hook"

condaUnpackPhase(){
    echo "Executing condaUnpackPhase"
    runHook preUnpack

    # use lbzip2 for parallel decompression (bz2 is slow)
    lbzip2 -dc -n $NIX_BUILD_CORES $src | tar --exclude='info' -x

    # runHook postUnpack # Calls find...?
    echo "Finished executing condaUnpackPhase"
}

if [ -z "${unpackPhase-}" ]; then
    echo "Using condaUnpackPhase"
    unpackPhase=condaUnpackPhase
fi
