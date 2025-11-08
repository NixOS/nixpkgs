{
  fetchpatch,
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

  patches = [
    # don't cache bytecode of bare qml files in the store, as that never gets cleaned up
    (replaceVars ./dont-cache-nix-store-paths.patch {
      nixStore = builtins.storeDir;
    })
    # add version specific QML import path
    ./use-versioned-import-path.patch
    # Fix common crash
    # https://bugreports.qt.io/browse/QTBUG-140018
    (fetchpatch {
      url = "https://invent.kde.org/qt/qt/qtdeclarative/-/commit/2b7f93da38d41ffaeb5322a7dca40ec26fc091a1.diff";
      hash = "sha256-AOXey18lJlswpZ8tpTTZeFb0VE9k1louXy8TPPGNiA4=";
    })
    # Fix another common crash
    # https://bugreports.qt.io/browse/QTBUG-139626
    (fetchpatch {
      url = "https://invent.kde.org/qt/qt/qtdeclarative/-/commit/0de0b0ffdb44d73c605e20f00934dfb44bdf7ad9.diff";
      hash = "sha256-DCoaSxH1MgywGXmmK21LLzCBi2KAmJIv5YKpFS6nw7M=";
    })
  ];

  cmakeFlags = [
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
