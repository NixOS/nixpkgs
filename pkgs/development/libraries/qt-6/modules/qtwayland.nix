{ qtModule
, qtbase
, qtquick3d
, qtdeclarative
, wayland
, pkg-config
, xlibsWrapper
, libdrm
}:

qtModule {
  pname = "qtwayland";
  qtInputs = [ qtbase qtdeclarative ];
  buildInputs = [ wayland xlibsWrapper libdrm ];
  nativeBuildInputs = [ pkg-config ];
}
