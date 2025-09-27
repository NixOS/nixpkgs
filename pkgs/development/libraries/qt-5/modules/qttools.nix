{
  qtModule,
  stdenv,
  lib,
  qtbase,
  qtdeclarative,
  qttools,
  replaceVars,
  llvmPackages,
}:

let
  isCrossBuild = stdenv.buildPlatform != stdenv.hostPlatform;
in

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
    qtbase
    qtdeclarative
  ];

  # We don't need this to build qttools itself, only for the packages that include qttools
  # in their buildInputs and expect to get not only libs but also runnable tools.
  propagatedNativeBuildInputs = lib.optional isCrossBuild qttools;

  patches = [
    # fixQtBuiltinPaths overwrites builtin paths we should keep
    (replaceVars ./qttools-QT_HOST_DATA-refs.patch {
      qtbaseDev = lib.getDev qtbase;
    })

    (replaceVars ./qttools-libclang-main-header.patch {
      libclangDev = lib.getDev llvmPackages.libclang;
    })
  ];

  # Bootstrap build produces no out, and that makes nix unhappy and results in an unannotated failure for remote builds.
  postFixup = ''[ -e $out ] || mkdir $out'';

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
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ "bin/macdeployqt" ];

  env.NIX_CFLAGS_COMPILE = lib.optionalString (
    stdenv.hostPlatform.isDarwin && qtdeclarative != null
  ) ''-DNIXPKGS_QMLIMPORTSCANNER="${qtdeclarative.dev}/bin/qmlimportscanner"'';

  setupHook = ../hooks/qttools-setup-hook.sh;
}
