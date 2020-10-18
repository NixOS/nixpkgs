{ qtModule, qtbase, wayland, pkgconfig }:

qtModule {
  name = "qtwayland";
  qtInputs = [ qtbase ];
  buildInputs = [ wayland ];
  nativeBuildInputs = [ pkgconfig ];
  outputs = [ "out" "dev" "bin" ];
}
