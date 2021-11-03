{ qtModule
, qtbase
, libglvnd, vulkan-headers # TODO should be inherited from qtbase
, libwebp
, jasper
, libmng
, libtiff
}:

qtModule {
  pname = "qtimageformats";
  qtInputs = [ qtbase ];
  buildInputs = [ libwebp jasper libmng libtiff libglvnd vulkan-headers ];
  hasPlugins = true;
}
