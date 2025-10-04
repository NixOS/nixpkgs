{
  lib,
  stdenv,
  qtModule,
  python3,
  qtbase,
  qtdeclarative,
}:

let
  isCrossBuild = stdenv.buildPlatform != stdenv.hostPlatform;
in

qtModule {
  pname = "qtdeclarative";
  buildInputs = [ qtbase ];
  nativeBuildInputs = [ python3 ];
  # We need a runnable qmlcachegen to build qtdeclarative itself, and some dependers
  # of this package also expect to get runnable tools with it.
  propagatedNativeBuildInputs = lib.optional isCrossBuild qtdeclarative;
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
