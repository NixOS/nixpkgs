{
  qtModule,
  stdenv,
  lib,
  qtbase,
  qtdeclarative,
  substituteAll,
  llvmPackages,
}:

qtModule {
  pname = "qttools";

  outputs = [
    "out"
    "dev"
    "bin"
  ];

  buildInputs = with llvmPackages; [
    libclang
    libllvm
  ];

  propagatedBuildInputs = [
    qtbase
    qtdeclarative
  ];

  patches = [
    # fixQtBuiltinPaths overwrites builtin paths we should keep
    (substituteAll {
      src = ./qttools-QT_HOST_DATA-refs.patch;
      qtbaseDev = lib.getDev qtbase;
    })

    (substituteAll {
      src = ./qttools-libclang-main-header.patch;
      libclangDev = lib.getDev llvmPackages.libclang;
    })
  ];

  devTools = [
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
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ "bin/macdeployqt" ];

  env.NIX_CFLAGS_COMPILE = lib.optionalString (
    stdenv.hostPlatform.isDarwin && qtdeclarative != null
  ) ''-DNIXPKGS_QMLIMPORTSCANNER="${qtdeclarative.dev}/bin/qmlimportscanner"'';

  setupHook = ../hooks/qttools-setup-hook.sh;
}
