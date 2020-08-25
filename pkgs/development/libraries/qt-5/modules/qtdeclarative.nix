{ qtModule, lib, python3, qtbase, qtsvg }:

with lib;

qtModule {
  name = "qtdeclarative";
  qtInputs = [ qtbase qtsvg ];
  nativeBuildInputs = [ python3 ];
  outputs = [ "out" "dev" "bin" ];
  preConfigure = ''
    NIX_CFLAGS_COMPILE+=" -DNIXPKGS_QML2_IMPORT_PREFIX=\"$qtQmlPrefix\""
  '';
  configureFlags = lib.optionals (lib.versionAtLeast qtbase.version "5.11.0") [ "-qml-debug" ];
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
}
