{ lib
, stdenv
, qtModule, python3, qtbase, qtsvg }:

qtModule {
  pname = "qtdeclarative";
  qtInputs = [ qtbase qtsvg ];
  nativeBuildInputs = [ python3 ];
  outputs = [ "out" "dev" "bin" ];
  preConfigure = ''
    NIX_CFLAGS_COMPILE+=" -DNIXPKGS_QML2_IMPORT_PREFIX=\"$qtQmlPrefix\""
  '';
  configureFlags = [ "-qml-debug" ];
  devTools = [
    "bin/qml"
    "bin/qmlcachegen"
    "bin/qmleasing"
    "bin/qmlimportscanner"
    "bin/qmllint"
    "bin/qmlmin"
    "bin/qmlplugindump"
    "bin/qmlprofiler"
    "bin/qmlscene"
    "bin/qmltestrunner"
  ];
  postFixup = lib.optionalString (stdenv.buildPlatform != stdenv.hostPlatform) ''
    mv $dev/bin/qmlformat $bin/bin/qmlformat
    mv $dev/bin/qmltyperegistrar $bin/bin/qmltyperegistrar
    ln -s $bin/bin/qmlformat $dev/bin/qmlformat
    ln -s $bin/bin/qmltyperegistrar $dev/bin/qmltyperegistrar
  '';
}
