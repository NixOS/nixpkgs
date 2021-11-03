{ qtModule
, qtbase
, libglvnd, libxkbcommon, vulkan-headers # TODO should be inherited from qtbase
, libwebp
, jasper
, libmng
, zlib
, pkg-config # find libwebp
}:

qtModule {
  pname = "qtsvg";
  qtInputs = [ qtbase ];
  buildInputs = [ libwebp jasper libmng zlib libglvnd libxkbcommon vulkan-headers ];
  nativeBuildInputs = [ pkg-config ];
  hasPlugins = true;
}
