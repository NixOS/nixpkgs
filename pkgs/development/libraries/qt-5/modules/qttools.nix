{ qtModule, stdenv, lib, qtbase, qtdeclarative }:

with lib;

qtModule {
  name = "qttools";
  qtInputs = [ qtbase qtdeclarative ];
  outputs = [ "out" "dev" "bin" ];

  # fixQtBuiltinPaths overwrites a builtin path we should keep
  postPatch = ''
    sed -i "src/linguist/linguist.pro" \
        -e '/^cmake_linguist_config_version_file.input =/ s|$$\[QT_HOST_DATA.*\]|${getDev qtbase}|'
  '';

  devTools = [
    "bin/qcollectiongenerator"
    "bin/linguist"
    "bin/assistant"
    "bin/qdoc"
    "bin/lconvert"
    "bin/designer"
    "bin/qtattributesscanner"
    "bin/lrelease"
    "bin/pixeltool"
    "bin/lupdate"
    "bin/qtdiag"
    "bin/qhelpgenerator"
    "bin/qtplugininfo"
    "bin/qthelpconverter"
  ] ++ optionals stdenv.isDarwin [
    "bin/macdeployqt"
  ];

  NIX_CFLAGS_COMPILE =
    lib.optional stdenv.isDarwin ''-DNIXPKGS_QMLIMPORTSCANNER="${qtdeclarative.dev}/bin/qmlimportscanner"'';

  setupHook = ../hooks/qttools-setup-hook.sh;
}
