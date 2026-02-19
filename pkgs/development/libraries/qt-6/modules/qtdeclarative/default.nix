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
  fetchpatch,
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

    # fix common Plasma crasher
    # FIXME: remove in 6.10.2
    (fetchpatch {
      url = "https://github.com/qt/qtdeclarative/commit/9c6b2b78e9076f1c2676aa0c41573db9ca480654.diff";
      hash = "sha256-KMFurA9Q84qwuyBraU3ZdoFWs8uO3uoUcinfcfh/ps8=";
    })

    # Backport of https://codereview.qt-project.org/c/qt/qtdeclarative/+/704031
    # Fixes common Plasma crash
    # FIXME: remove in 6.10.3
    ./another-crash-fix.patch

    # https://qt-project.atlassian.net/browse/QTBUG-137440
    (fetchpatch {
      name = "rb-dialogs-link-labsfolderlistmodel-into-quickdialogs2quickimpl.patch";
      url = "https://github.com/qt/qtdeclarative/commit/4047fa8c6017d8e214e6ec3ddbed622fd34058e4.patch";
      hash = "sha256-0a7a1AI8N35rqLY4M3aSruXXPBqz9hX2yT65r/xzfhc=";
    })
    (fetchpatch {
      name = "rb-quickcontrols-fix-controls-styles-linkage.patch";
      url = "https://github.com/qt/qtdeclarative/commit/aa805ed54d55479360e0e95964dcc09a858aeb28.patch";
      hash = "sha256-EDdsXRokHPQ5jflaVucOZP3WSopMjrAM39WZD1Hk/5I=";
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
