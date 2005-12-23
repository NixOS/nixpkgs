source $stdenv/setup

postInstall() {
  ensureDir $out/lib
  ensureDir $out/include/pci
  cp lib/*.h $out/include/pci
  cp lib/libpci.a $out/lib
}

postInstall=postInstall

genericBuild
