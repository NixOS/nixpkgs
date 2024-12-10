{
  qtModule,
  stdenv,
  lib,
  qtbase,
  qtdeclarative,
}:

qtModule {
  pname = "qttools";
  propagatedBuildInputs = [
    qtbase
    qtdeclarative
  ];
  outputs = [
    "out"
    "dev"
    "bin"
  ];

  # fixQtBuiltinPaths overwrites a builtin path we should keep
  postPatch = ''
    sed -i "src/linguist/linguist.pro" \
        -e '/^cmake_linguist_config_version_file.input =/ s|$$\[QT_HOST_DATA.*\]|${lib.getDev qtbase}|'
    sed -i "src/qtattributionsscanner/qtattributionsscanner.pro" \
        -e '/^cmake_qattributionsscanner_config_version_file.input =/ s|$$\[QT_HOST_DATA.*\]|${lib.getDev qtbase}|'
  '';

  devTools =
    [
      "bin/qcollectiongenerator"
      "bin/linguist"
      "bin/assistant"
      "bin/qdoc"
      "bin/lconvert"
      "bin/designer"
      "bin/qtattributionsscanner"
      "bin/lrelease"
      "bin/lrelease-pro"
      "bin/pixeltool"
      "bin/lupdate"
      "bin/lupdate-pro"
      "bin/qtdiag"
      "bin/qhelpgenerator"
      "bin/qtplugininfo"
      "bin/qthelpconverter"
      "bin/lprodump"
      "bin/qdistancefieldgenerator"
    ]
    ++ lib.optionals stdenv.isDarwin [
      "bin/macdeployqt"
    ];

  env.NIX_CFLAGS_COMPILE = lib.optionalString (
    stdenv.isDarwin && qtdeclarative != null
  ) ''-DNIXPKGS_QMLIMPORTSCANNER="${qtdeclarative.dev}/bin/qmlimportscanner"'';

  setupHook = ../hooks/qttools-setup-hook.sh;
}
