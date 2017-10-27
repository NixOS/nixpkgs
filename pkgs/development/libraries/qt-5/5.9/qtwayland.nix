{ qtSubmodule, qtbase, qtquickcontrols, wayland, pkgconfig }:

qtSubmodule {
  name = "qtwayland";
  qtInputs = [ qtbase qtquickcontrols ];
  buildInputs = [ wayland ];
  nativeBuildInputs = [ pkgconfig ];
  outputs = [ "bin" "dev" "out" ];
  postInstall = ''
    moveToOutput "$qtPluginPrefix" "$bin"
    moveToOutput "$qtQmlPrefix" "$bin"
  '';
}
