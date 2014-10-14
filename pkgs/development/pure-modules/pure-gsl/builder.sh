source $stdenv/setup

installPhase() {
    mkdir -p $out/lib/pure/gsl
    install gsl.pure gsl$(pkg-config pure --variable DLL) $out/lib/pure
    install gsl/*.pure $out/lib/pure/gsl
}

genericBuild
