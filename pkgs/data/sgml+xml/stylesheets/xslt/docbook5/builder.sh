source $stdenv/setup

buildPhase=true

installPhase=myInstallPhase
myInstallPhase() {
    ensureDir $out/xml/xsl
    cd ..
    mv docbook-xsl-ns-* $out/xml/xsl/docbook
}

genericBuild
