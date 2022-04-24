{ stdenv, fetchurl, qtdeclarative , qttools, qtbase, qmake }:

stdenv.mkDerivation rec {
  pname = "qtinstaller";

  propagatedBuildInputs = [ qtdeclarative qttools ];
  nativeBuildInputs = [ qmake ];

  version = "2.0.3";
  src = fetchurl {
    url = "http://download.qt.io/official_releases/qt-installer-framework/${version}/qt-installer-framework-opensource-${version}-src.tar.gz";
    sha256 = "003gwjg02isw8qjyka377g1ahlisfyi44l6xfa4hvvdgqqq0hy2f";
    name = "qt-installer-framework-opensource-src-${version}.tar.gz";
  };

  outputs = [ "out" "dev" "doc" ];

  setOutputFlags = false;
  NIX_QT_SUBMODULE = true;
  dontWrapQtApps = true;

  installPhase = ''
    mkdir -p $out/{bin,lib,share/qt-installer-framework}
    cp -a bin/{archivegen,binarycreator,devtool,installerbase,repogen} $out/bin
    cp -a lib/{libinstaller.so*,lib7z.a} $out/lib
    cp -a examples $out/share/qt-installer-framework/
  '';

  postFixup = ''
    moveToOutput "bin/archivegen" "$out"
    moveToOutput "bin/binarycreator" "$out"
    moveToOutput "bin/devtool" "$out"
    moveToOutput "bin/installerbase" "$out"
    moveToOutput "bin/repogen" "$out"
    moveToOutput "share" "$doc"
    moveToOutput "lib/libinstaller.so" "$out"
    moveToOutput "lib/libinstaller.so.1" "$out"
    moveToOutput "lib/libinstaller.so.1.0" "$out"
    moveToOutput "lib/libinstaller.so.1.0.0" "$out"
  '';

  meta = {
    description = "Qt installer framework";
    inherit (qtbase.meta) platforms license homepage;
  };
}
