. @fix_qmake_libtool@

qmakeFlags=(${qmakeFlags-})

qmakePrePhase() {
    qmakeFlags_orig=("${qmakeFlags[@]}")

    # These flags must be added _before_ the flags specified in the derivation.
    # TODO: these flags also need a patch which isn't applied
    # can we either remove these flags or update the qt5 patch?
    # "NIX_OUTPUT_DOC=${!outputDev}/${qtDocPrefix:?}" \
    qmakeFlags=(
        "PREFIX=$out"
        "NIX_OUTPUT_OUT=$out"
        "NIX_OUTPUT_DEV=${!outputDev}"
        "NIX_OUTPUT_BIN=${!outputBin}"
        "NIX_OUTPUT_QML=${!outputBin}/${qtQmlPrefix:?}"
        "NIX_OUTPUT_PLUGIN=${!outputBin}/${qtPluginPrefix:?}"
    )

    if [ -n "@debug@" ]; then
        qmakeFlags+=("CONFIG+=debug")
    else
        qmakeFlags+=("CONFIG+=release")
    fi

    qmakeFlags+=("${qmakeFlags_orig[@]}")
}
prePhases+=" qmakePrePhase"

qmakeConfigurePhase() {
    runHook preConfigure

    echo "QMAKEPATH=$QMAKEPATH"
    echo qmake "${qmakeFlags[@]}"
    qmake "${qmakeFlags[@]}"

    if ! [[ -v enableParallelBuilding ]]; then
        enableParallelBuilding=1
        echo "qmake: enabled parallel building"
    fi

    if ! [[ -v enableParallelInstalling ]]; then
        enableParallelInstalling=1
        echo "qmake: enabled parallel installing"
    fi

    runHook postConfigure
}

if [ -z "${dontUseQmakeConfigure-}" -a -z "${configurePhase-}" ]; then
    configurePhase=qmakeConfigurePhase
fi
