{ qtModule
, qtbase
, qtlanguageserver
, qtshadertools
, openssl
, stdenv
, lib
, pkgsBuildBuild
, fetchpatch2
, replaceVars
}:

qtModule {
  pname = "qtdeclarative";

  propagatedBuildInputs = [ qtbase qtlanguageserver qtshadertools openssl ];
  strictDeps = true;

  patches = [
    # invalidates qml caches created from nix applications at different
    # store paths and disallows saving caches of bare qml files in the store.
    (replaceVars ../patches/0001-qtdeclarative-invalidate-caches-from-mismatched-store-paths.patch {
      nixStore = builtins.storeDir;
      nixStoreLength = builtins.toString ((builtins.stringLength builtins.storeDir) + 1); # trailing /
    })
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
  ];

  preConfigure = let
    storePrefixLen = builtins.toString ((builtins.stringLength builtins.storeDir) + 1);
  in ''
    # "NIX:" is reserved for saved qmlc files in patch 0001, "QTDHASH:" takes the place
    # of the old tag, which is otherwise the qt version, invalidating caches from other
    # qtdeclarative store paths.
    echo "QTDHASH:''${out:${storePrefixLen}:32}" > .tag
  '';

  cmakeFlags = [
    "-DQt6ShaderToolsTools_DIR=${pkgsBuildBuild.qt6.qtshadertools}/lib/cmake/Qt6ShaderTools"
    # for some reason doesn't get found automatically on Darwin
    "-DPython_EXECUTABLE=${lib.getExe pkgsBuildBuild.python3}"
  ]

  # Conditional is required to prevent infinite recursion during a cross build
  ++ lib.optionals (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
    "-DQt6QmlTools_DIR=${pkgsBuildBuild.qt6.qtdeclarative}/lib/cmake/Qt6QmlTools"
  ];
}
