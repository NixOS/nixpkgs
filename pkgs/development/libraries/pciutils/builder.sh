source $stdenv/setup

postInstall() {
  ensureDir $out/lib
  ensureDir $out/include
  cp lib/*.h $out/include
  cp lib/libpci.a $out/lib
}

postInstall=postInstall

genericBuild
