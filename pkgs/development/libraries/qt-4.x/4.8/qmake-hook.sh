qmakeConfigurePhase() {
    runHook preConfigure

    $QMAKE PREFIX=$out $qmakeFlags

    if ! [[ -v enableParallelBuilding ]]; then
        enableParallelBuilding=1
        echo "qmake4Hook: enabled parallel building"
    fi

    runHook postConfigure
}

export QMAKE=@qt4@/bin/qmake

configurePhase=qmakeConfigurePhase
