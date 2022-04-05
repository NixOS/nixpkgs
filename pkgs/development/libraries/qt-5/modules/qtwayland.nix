{ qtModule, qtbase, qtquickcontrols, wayland, pkg-config }:

qtModule {
  pname = "qtwayland";
  qtInputs = [ qtbase qtquickcontrols ];
  buildInputs = [ wayland ];
  nativeBuildInputs = [ pkg-config ];
  outputs = [ "out" "dev" "bin" ];
}
