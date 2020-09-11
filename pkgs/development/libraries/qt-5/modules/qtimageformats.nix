{ qtModule, qtbase, libtiff }:

qtModule {
  name = "qtimageformats";
  qtInputs = [ qtbase ];
  propagatedBuildInputs = [ libtiff ];
}
