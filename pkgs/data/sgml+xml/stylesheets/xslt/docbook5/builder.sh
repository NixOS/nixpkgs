source $stdenv/setup

buildPhase=true

installPhase=myInstallPhase
myInstallPhase() {
    ensureDir $out/xml/xsl
    cd ..
    mv docbook5-xsl-* $out/xml/xsl/docbook
}

genericBuild
