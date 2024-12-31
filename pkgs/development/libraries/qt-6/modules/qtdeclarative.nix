{
  qtModule,
  qtbase,
  qtlanguageserver,
  qtshadertools,
  openssl,
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

  patches = [
    # prevent headaches from stale qmlcache data
    ../patches/0001-qtdeclarative-disable-qml-disk-cache.patch
    # add version specific QML import path
    ../patches/0002-qtdeclarative-also-use-versioned-qml-paths.patch

    # Backport patches for https://bugs.kde.org/show_bug.cgi?id=493116
    # FIXME: remove for 6.8.1
    (fetchpatch2 {
      url = "https://github.com/qt/qtdeclarative/commit/3330731d0cb221477ab3d856db032126403ae6a0.patch";
      hash = "sha256-XXXGJ7nVDpEG/6nr16L89J87tvutyc+YnQPQx9cRU+w=";
    })
    (fetchpatch2 {
      url = "https://github.com/qt/qtdeclarative/commit/2aefbca84d2f3dca2c2697f13710b6907c0c7e59.patch";
      hash = "sha256-a/BX0gpW6juJbjDRo8OleMahOC6WWqreURmYZNiGm5c=";
    })
    # Backport patch to fix Kirigami applications crashing
    # FIXME: remove for 6.8.1
    (fetchpatch2 {
      url = "https://github.com/qt/qtdeclarative/commit/0ae3697cf40bcd3ae1de20621abad17cf6c5f52d.patch";
      hash = "sha256-YuTHqHCWOsqUOATfaAZRxPSwMsFNylxoqnqCeW5kPjs=";
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
