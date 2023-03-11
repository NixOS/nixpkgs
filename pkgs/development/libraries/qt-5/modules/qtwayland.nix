{ lib
, stdenv
, qtModule, qtbase, qtquickcontrols, wayland, pkg-config, fetchpatch
, buildPackages }:

qtModule {
  pname = "qtwayland";
  qtInputs = [ qtbase qtquickcontrols ];
  buildInputs = [ wayland ];
  nativeBuildInputs = [
    pkg-config
    buildPackages.wayland   # for wayland-scanner
  ];
  outputs = [ "out" "dev" ] ++ lib.optionals (stdenv.buildPlatform.canExecute stdenv.hostPlatform) [ "bin" ];
  patches = [
    # NixOS-specific, ensure that app_id is correctly determined for
    # wrapped executables from `wrapQtAppsHook` (see comment in patch for further
    # context).
    ./qtwayland-app_id.patch
  ];
}
