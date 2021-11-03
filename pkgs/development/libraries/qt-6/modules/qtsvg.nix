{ pkg-config
, qtModule
, qtbase
, libwebp
# FIXME not found by cmake: libwebp-1.1.0/lib/libwebp.so.7.1.0
, jasper
, libmng
, zlib
, libglvnd
, libxkbcommon
, vulkan-headers
}:

qtModule {
  pname = "qtsvg";
  qtInputs = [ qtbase libwebp jasper libmng zlib pkg-config
    libglvnd libxkbcommon # TODO these should be inherited from qtbase
  ];
  outputs = [ "out" "dev" ];
}
