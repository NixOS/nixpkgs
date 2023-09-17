{ qtModule, qtbase, libtiff, libwebp }:

qtModule {
  pname = "qtimageformats";
  qtInputs = [ qtbase ];
  propagatedBuildInputs = [ libtiff libwebp ];
}
