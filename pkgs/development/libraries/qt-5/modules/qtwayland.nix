{ qtModule, qtbase, qtquickcontrols, wayland, pkg-config }:

qtModule {
  pname = "qtwayland";
  qtInputs = [ qtbase qtquickcontrols ];
  buildInputs = [ wayland ];
  nativeBuildInputs = [ pkg-config ];
  outputs = [ "out" "dev" "bin" ];
  patches = [
    # NixOS-specific, ensure that app_id is correctly determined for
    # wrapped executables from `wrapQtAppsHook` (see comment in patch for further
    # context).
    ./qtwayland-app_id.patch
  ];
}
