{ lib, stdenv, fetchurl, qt4 }:

stdenv.mkDerivation rec {
  pname = "qtscriptgenerator";
  version = "0.1.0";

  src = fetchurl {
    url = "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/qtscriptgenerator/qtscriptgenerator-src-${version}.tar.gz";
    sha256 = "0h8zjh38n2wfz7jld0jz6a09y66dbsd2jhm4f2024qfgcmxcabj6";
  };
  buildInputs = [ qt4 ];

  patches = [ ./qtscriptgenerator.gcc-4.4.patch ./qt-4.8.patch ];

  postPatch = ''
    # remove phonon stuff which causes errors (thanks to Gentoo bug reports)
    sed -i "/typesystem_phonon.xml/d" generator/generator.qrc
    sed -i "/qtscript_phonon/d" qtbindings/qtbindings.pro
  '';

  configurePhase = ''
    ( cd generator; qmake )
    ( cd qtbindings; qmake )
  '';

  buildPhase = ''
    makeFlags="SHELL=$SHELL ''${enableParallelBuilding:+-j$NIX_BUILD_CORES -l$NIX_BUILD_CORES}"
    make $makeFlags -C generator

    # Set QTDIR, see https://code.google.com/archive/p/qtscriptgenerator/issues/38
    ( cd generator; QTDIR=${qt4} ./generator )
    make $makeFlags -C qtbindings
  '';

  installPhase = ''
    mkdir -p $out/lib/qt4/plugins/script
    cp -av plugins/script/* $out/lib/qt4/plugins/script
  '';

  enableParallelBuilding = true;

  hardeningDisable = [ "format" ];

  meta = {
    broken = (stdenv.isLinux && stdenv.isAarch64);
    description = "QtScript bindings generator";
    homepage = "https://code.qt.io/cgit/qt-labs/qtscriptgenerator.git/";
    inherit (qt4.meta) platforms;
    license = lib.licenses.lgpl21;
  };
}
