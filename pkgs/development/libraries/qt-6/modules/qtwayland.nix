{ qtModule
, qtbase
, qtdeclarative
, wayland
, pkg-config
, libdrm
}:

qtModule {
  pname = "qtwayland";
  propagatedBuildInputs = [ qtbase qtdeclarative ];
  buildInputs = [ wayland libdrm ];
  nativeBuildInputs = [ pkg-config ];
}
