{ qtModule, qtbase, qtquickcontrols, wayland, pkg-config }:

qtModule {
  name = "qtwayland";
  qtInputs = [ qtbase qtquickcontrols ];
  buildInputs = [ wayland ];
  nativeBuildInputs = [ pkg-config ];
  outputs = [ "out" "dev" "bin" ];
}
