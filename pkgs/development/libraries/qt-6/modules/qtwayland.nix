{ qtModule, qtbase, wayland, pkg-config }:

qtModule {
  pname = "qtwayland";
  qtInputs = [ qtbase ];
  buildInputs = [ wayland ];
  nativeBuildInputs = [ pkg-config ];
  outputs = [ "out" "dev" "bin" ];
}
