{
  qtModule,
  qtbase,
  qtdeclarative,
  qtwayland,
  wayland,
  wayland-scanner,
  pkg-config,
  buildPackages,
  stdenv,
  lib,
}:

let
  isCrossBuild = stdenv.buildPlatform != stdenv.hostPlatform;
in

qtModule {
  pname = "qtwayland";
  propagatedBuildInputs = [ qtbase ];
  buildInputs = [
    wayland
    qtdeclarative
  ];
  nativeBuildInputs = [
    pkg-config
    wayland-scanner
  ]
  ++ lib.optional isCrossBuild qtwayland.bin;
  outputs = [
    "out"
    "dev"
    "bin"
  ];
  patches = [
    # NixOS-specific, ensure that app_id is correctly determined for
    # wrapped executables from `wrapQtAppsHook` (see comment in patch for further
    # context).
    ./qtwayland-app_id.patch
  ];
  disallowedReferences = lib.optional isCrossBuild buildPackages.qt5.qtwayland.bin;
  meta.badPlatforms = lib.platforms.darwin;
}
