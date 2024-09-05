{ qtModule
, qtbase
, qtlanguageserver
, qtshadertools
, openssl
, stdenv
, lib
, pkgsBuildBuild
}:

qtModule {
  pname = "qtdeclarative";

  propagatedBuildInputs = [ qtbase qtlanguageserver qtshadertools openssl ];
  strictDeps = true;

  patches = [
    # invalidates qml caches created from nix applications at different
    # store paths and disallows saving caches of bare qml files in the store.
    ../patches/qtdeclarative-invalidate-caches-from-mismatched-store-paths.patch
    # add version specific QML import path
    ../patches/0002-qtdeclarative-also-use-versioned-qml-paths.patch
  ];

  # Only qml files with a matching tag will be loaded by qtdeclarative,
  # so it is set to the unique store path of the build.
  # The maximum length of the tag is 48 bytes, so the path is trimmed to
  # only /nix/store/<hash>.
  preConfigure = ''
    echo ''${out:0:43} > .tag
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
