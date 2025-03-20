{
  qtModule,
  python3,
  qtbase,
  qtsvg,
}:

qtModule {
  pname = "qtdeclarative";
  propagatedBuildInputs = [
    qtbase
    qtsvg
  ];
  nativeBuildInputs = [ python3 ];
  outputs = [
    "out"
    "dev"
    "bin"
  ];
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
}
