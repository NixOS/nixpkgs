{ qtModule, qtbase, libtiff }:

qtModule {
  pname = "qtimageformats";
  qtInputs = [ qtbase ];
  propagatedBuildInputs = [ libtiff ];
}
