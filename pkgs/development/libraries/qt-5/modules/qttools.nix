{
  qtModule,
  stdenv,
  lib,
  qtbase,
  qtdeclarative,
  substituteAll,
  # clang-based c++ parser for qdoc and lupdate
  withClang ? false,
  llvmPackages,
}:

qtModule {
  pname = "qttools";

  outputs = [
    "out"
    "dev"
    "bin"
  ];

  buildInputs = lib.optionals withClang (with llvmPackages; [
    libclang
    libllvm
  ]);

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
  ];

  postPatch = ''
    # llvm-config --includedir gives libllvm includedir, looks for libclang header there
    substituteInPlace src/qdoc/configure.pri \
      --replace-fail "\''$\''$CLANG_INCLUDEPATH/clang-c" "${lib.getDev llvmPackages.libclang}/include/clang-c"
  '';

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
  ] ++ lib.optionals stdenv.isDarwin [ "bin/macdeployqt" ];

  env.NIX_CFLAGS_COMPILE = lib.optionalString (
    stdenv.isDarwin && qtdeclarative != null
  ) ''-DNIXPKGS_QMLIMPORTSCANNER="${qtdeclarative.dev}/bin/qmlimportscanner"'';

  setupHook = ../hooks/qttools-setup-hook.sh;
}
