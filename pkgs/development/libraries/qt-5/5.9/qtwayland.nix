{ qtSubmodule, qtbase, qtquickcontrols, wayland, pkgconfig }:

qtSubmodule {
  name = "qtwayland";
  qtInputs = [ qtbase qtquickcontrols ];
  buildInputs = [ wayland ];
  nativeBuildInputs = [ pkgconfig ];
  outputs = [ "out" "dev" "bin" ];
  postInstall = ''
    moveToOutput "$qtPluginPrefix" "$bin"
    moveToOutput "$qtQmlPrefix" "$bin"
  '';
}
