{ qtModule, qtbase, qtquickcontrols2, wayland, pkgconfig }:

qtModule {
  name = "qtwayland";
  qtInputs = [ qtbase qtquickcontrols2 ];
  buildInputs = [ wayland ];
  nativeBuildInputs = [ pkgconfig ];
  outputs = [ "out" "dev" "bin" ];
}
