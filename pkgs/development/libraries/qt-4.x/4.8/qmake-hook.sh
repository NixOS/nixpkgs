qmakeConfigurePhase() {
    runHook preConfigure

    $QMAKE PREFIX=$out $qmakeFlags

    if ! [[ -v enableParallelBuilding ]]; then
        enableParallelBuilding=1
        echo "qmake4Hook: enabled parallel building"
    fi

    if ! [[ -v enableParallelInstalling ]]; then
        enableParallelInstalling=1
        echo "qmake: enabled parallel installing"
    fi

    runHook postConfigure
}

export QMAKE=@qt4@/bin/qmake

configurePhase=qmakeConfigurePhase
