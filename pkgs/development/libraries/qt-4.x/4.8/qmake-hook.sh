qmakeConfigurePhase() {
    runHook preConfigure

    $QMAKE PREFIX=$out $qmakeFlags

    runHook postConfigure
}

export QMAKE=@qt4@/bin/qmake

configurePhase=qmakeConfigurePhase
