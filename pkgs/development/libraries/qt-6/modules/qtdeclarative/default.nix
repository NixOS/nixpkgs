{
  qtModule,
  qtbase,
  qtlanguageserver,
  qtshadertools,
  qtsvg,
  openssl,
  darwin,
  stdenv,
  lib,
  pkgsBuildBuild,
  replaceVars,
  fetchpatch2,
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

  nativeBuildInputs = lib.optionals stdenv.isDarwin [
    darwin.sigtool
  ];

  patches = [
    # invalidates qml caches created from nix applications at different
    # store paths and disallows saving caches of bare qml files in the store.
    (replaceVars ./invalidate-caches-from-mismatched-store-paths.patch {
      nixStore = builtins.storeDir;
      nixStoreLength = builtins.toString ((builtins.stringLength builtins.storeDir) + 1); # trailing /
    })
    # add version specific QML import path
    ./use-versioned-import-path.patch

    # The build attempts to sign qmltestrunner, which may already be signed, causing it to fail unless forced.
    # FIXME: remove for 6.9.1
    (fetchpatch2 {
      url = "https://invent.kde.org/qt/qt/qtdeclarative/-/commit/8effbbcefd8cae27cd5da07b4ffe3aa86dad83bf.diff";
      hash = "sha256-wKrKXdr1ddshpRVIZZ/dsn87wjPXSaoUvXT9edlPtzA=";
    })

    # Backport patch to fix qmlsc crash on "if + for"
    # FIXME: remove for 6.9.1
    (fetchpatch2 {
      url = "https://github.com/qt/qtdeclarative/commit/d1aa2e8466bab73c3e4d120356238b482b55f02a.patch?full_index=1";
      hash = "sha256-8W1xpULqESP81S4UbQugoU/D6KFy7DoTbJ3xfK9Q5PI=";
    })
  ];

  preConfigure =
    let
      storePrefixLen = builtins.toString ((builtins.stringLength builtins.storeDir) + 1);
    in
    ''
      # "NIX:" is reserved for saved qmlc files in patch 0001, "QTDHASH:" takes the place
      # of the old tag, which is otherwise the qt version, invalidating caches from other
      # qtdeclarative store paths.
      echo "QTDHASH:''${out:${storePrefixLen}:32}" > .tag
    '';

  cmakeFlags =
    [
      "-DQt6ShaderToolsTools_DIR=${pkgsBuildBuild.qt6.qtshadertools}/lib/cmake/Qt6ShaderTools"
      # for some reason doesn't get found automatically on Darwin
      "-DPython_EXECUTABLE=${lib.getExe pkgsBuildBuild.python3}"
    ]
    # Conditional is required to prevent infinite recursion during a cross build
    ++ lib.optionals (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
      "-DQt6QmlTools_DIR=${pkgsBuildBuild.qt6.qtdeclarative}/lib/cmake/Qt6QmlTools"
    ];

  meta.maintainers = with lib.maintainers; [
    nickcao
    outfoxxed
  ];
}
