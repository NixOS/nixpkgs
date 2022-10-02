{ lib, mkDerivation, appstream, qtbase, qttools, nixosTests }:

# TODO: look into using the libraries from the regular appstream derivation as we keep duplicates here

mkDerivation {
  pname = "appstream-qt";
  inherit (appstream) version src;

  outputs = [ "out" "dev" "installedTests" ];

  buildInputs = appstream.buildInputs ++ [ appstream qtbase ];

  nativeBuildInputs = appstream.nativeBuildInputs ++ [ qttools ];

  mesonFlags = appstream.mesonFlags ++ [ "-Dqt=true" ];

  patches = (appstream.patches or []) ++ lib.optionals (lib.versionOlder qtbase.version "5.14") [
    # Fix darwin build for libsForQt5.appstream-qt
    # Old Qt moc doesn't know about fancy C++14 features
    # ../qt/component.h:93: Parse error at "UrlTranslate"
    # Remove both this patch and related comment in default.nix
    # once Qt 5.14 or later becomes default on darwin
    ./fix-build-for-qt-olderthan-514.patch
  ];

  postFixup = ''
    sed -i "$dev/lib/cmake/AppStreamQt/AppStreamQtConfig.cmake" \
      -e "/INTERFACE_INCLUDE_DIRECTORIES/ s@\''${PACKAGE_PREFIX_DIR}@$dev@"
  '';

  passthru = appstream.passthru // {
    tests = {
      installed-tests = nixosTests.installed-tests.appstream-qt;
    };
  };

  meta = appstream.meta // {
    description = "Software metadata handling library - Qt";
 };
}
