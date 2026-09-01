{
  lib,
  stdenv,
  appstream,
  qtbase,
  qttools,
  nixosTests,
}:

# TODO: look into using the libraries from the regular appstream derivation as we keep duplicates here

stdenv.mkDerivation {
  pname = "appstream-qt";
  inherit (appstream) version src;

  outputs = [
    "out"
    "dev"
    "installedTests"
  ];

  buildInputs = appstream.buildInputs ++ [
    appstream
    qtbase
  ];

  nativeBuildInputs = appstream.nativeBuildInputs ++ [ qttools ];

  mesonFlags = appstream.mesonFlags ++ [
    (lib.mesonBool "qt" true)
  ];

  patches = appstream.patches;

  dontWrapQtApps = true;

  # AppStreamQt tries to be relocatable, in hacky cmake ways that generally fail
  # horribly on NixOS. Just hardcode the paths.
  postFixup = ''
    sed -i "$dev/lib/cmake/AppStreamQt/AppStreamQtConfig.cmake" \
      -e "/INTERFACE_INCLUDE_DIRECTORIES/ s@\''${PACKAGE_PREFIX_DIR}@$dev@"
    sed -i "$dev/lib/cmake/AppStreamQt/AppStreamQtConfig.cmake" \
      -e "/IMPORTED_LOCATION/ s@\''${PACKAGE_PREFIX_DIR}@$out@"
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
