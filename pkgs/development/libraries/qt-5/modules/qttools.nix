{ qtModule, stdenv, lib, qtbase, qtdeclarative, qttools }:

let
  isCrossBuild = stdenv.buildPlatform != stdenv.hostPlatform;
in

qtModule {
  pname = "qttools";
  buildInputs = [ qtbase qtdeclarative ];
  # We don't need this to build qttools itself, only for the packages that include qttools
  # in their buildInputs and expect to get not only libs but also runnable tools.
  propagatedNativeBuildInputs = lib.optional isCrossBuild qttools;
  outputs = [ "out" "dev" "bin" ];

  # fixQtBuiltinPaths overwrites a builtin path we should keep
  postPatch = ''
    sed -i "src/linguist/linguist.pro" \
        -e '/^cmake_linguist_config_version_file.input =/ s|$$\[QT_HOST_DATA.*\]|${lib.getDev qtbase}|'
    sed -i "src/qtattributionsscanner/qtattributionsscanner.pro" \
        -e '/^cmake_qattributionsscanner_config_version_file.input =/ s|$$\[QT_HOST_DATA.*\]|${lib.getDev qtbase}|'
  '';

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
  ] ++ lib.optionals stdenv.isDarwin [
    "bin/macdeployqt"
  ];

  env.NIX_CFLAGS_COMPILE = lib.optionalString (stdenv.isDarwin && qtdeclarative != null) ''-DNIXPKGS_QMLIMPORTSCANNER="${qtdeclarative.dev}/bin/qmlimportscanner"'';

  setupHook = ../hooks/qttools-setup-hook.sh;
}
