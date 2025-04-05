{
  qtModule,
  qtbase,
  qtlanguageserver,
  qtshadertools,
  openssl,
  darwin,
  stdenv,
  lib,
  pkgsBuildBuild,
  fetchpatch2,
}:

qtModule {
  pname = "qtdeclarative";

  propagatedBuildInputs = [
    qtbase
    qtlanguageserver
    qtshadertools
    openssl
  ];
  strictDeps = true;

  nativeBuildInputs = lib.optionals stdenv.isDarwin [
    darwin.sigtool
  ];

  patches =
    [
      # prevent headaches from stale qmlcache data
      ./disable-disk-cache.patch
      # add version specific QML import path
      ./use-versioned-import-path.patch
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      # The build attempts to sign qmltestrunner, which may already be signed, causing it to fail unless forced.
      (fetchpatch2 {
        url = "https://invent.kde.org/qt/qt/qtdeclarative/-/commit/8effbbcefd8cae27cd5da07b4ffe3aa86dad83bf.diff";
        hash = "sha256-wKrKXdr1ddshpRVIZZ/dsn87wjPXSaoUvXT9edlPtzA=";
      })
    ];

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
}
