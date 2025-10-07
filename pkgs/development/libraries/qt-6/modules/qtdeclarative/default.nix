{
  qtModule,
  qtbase,
  qtlanguageserver,
  qtshadertools,
  qtdeclarative,
  qtsvg,
  openssl,
  darwin,
  stdenv,
  lib,
  pkgsBuildHost,
  replaceVars,
}:

qtModule {
  pname = "qtdeclarative";

  propagatedBuildInputs = [
    qtbase
    qtlanguageserver
    qtshadertools
    qtsvg
    openssl
  ];
  strictDeps = true;

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    darwin.sigtool
  ];

  # When cross building, qtdeclarative depends on tools from the host version of itself
  propagatedNativeBuildInputs = lib.optionals (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
    qtdeclarative
    qtshadertools
  ];

  patches = [
    # invalidates qml caches created from nix applications at different
    # store paths and disallows saving caches of bare qml files in the store.
    (replaceVars ./invalidate-caches-from-mismatched-store-paths.patch {
      nixStore = builtins.storeDir;
      nixStoreLength = toString ((builtins.stringLength builtins.storeDir) + 1); # trailing /
    })
    # add version specific QML import path
    ./use-versioned-import-path.patch

    # Fix common crash
    # Manual backport of https://invent.kde.org/qt/qt/qtdeclarative/-/commit/b1ee7061ba77a7f5dc4148129bb2083f5c28e039
    # https://bugreports.qt.io/browse/QTBUG-140018
    ./stackview-crash.patch
  ];

  preConfigure =
    let
      storePrefixLen = toString ((builtins.stringLength builtins.storeDir) + 1);
    in
    ''
      # "NIX:" is reserved for saved qmlc files in patch 0001, "QTDHASH:" takes the place
      # of the old tag, which is otherwise the qt version, invalidating caches from other
      # qtdeclarative store paths.
      echo "QTDHASH:''${out:${storePrefixLen}:32}" > .tag
    '';

  cmakeFlags = [
    # for some reason doesn't get found automatically on Darwin
    "-DPython_EXECUTABLE=${lib.getExe pkgsBuildHost.python3}"
  ];

  meta.maintainers = with lib.maintainers; [
    nickcao
    outfoxxed
  ];
}
