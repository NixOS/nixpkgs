{ qtModule, lib, python2, qtbase, qtsvg, qtxmlpatterns }:

with lib;

qtModule {
  name = "qtdeclarative";
  qtInputs = [ qtbase qtsvg qtxmlpatterns ];
  nativeBuildInputs = [ python2 ];
  outputs = [ "out" "dev" "bin" ];
  preConfigure = ''
    NIX_CFLAGS_COMPILE+=" -DNIXPKGS_QML2_IMPORT_PREFIX=\"$qtQmlPrefix\""
  '';
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
