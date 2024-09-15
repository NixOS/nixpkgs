. @fix_qmake_libtool@

qmakePrePhase() {
    # These flags must be added _before_ the flags specified in the derivation.
    # TODO: these flags also need a patch which isn't applied
    # can we either remove these flags or update the qt5 patch?
    # "NIX_OUTPUT_DOC=${!outputDev}/${qtDocPrefix:?}" \
    prependToVar qmakeFlags \
      "PREFIX=$out" \
      "NIX_OUTPUT_OUT=$out" \
      "NIX_OUTPUT_DEV=${!outputDev}" \
      "NIX_OUTPUT_BIN=${!outputBin}" \
      "NIX_OUTPUT_QML=${!outputBin}/${qtQmlPrefix:?}" \
      "NIX_OUTPUT_PLUGIN=${!outputBin}/${qtPluginPrefix:?}"
}
prePhases+=" qmakePrePhase"

qmakeConfigurePhase() {
    runHook preConfigure

    local flagsArray=()
    concatTo flagsArray qmakeFlags

    echo "QMAKEPATH=$QMAKEPATH"
    echo qmake "${flagsArray[@]}"
    qmake "${flagsArray[@]}"

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
