{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "aterm-2.4.2-fixes-r2";
  
  src = fetchurl {
    url = http://nixos.org/tarballs/aterm-2.4.2-fixes-r2.tar.bz2;
    sha256 = "1w3bxdpc2hz29li5ssmdcz3x0fn47r7g62ns0v8nazxwf40vff4j";
  };

  patches = [
    # Fix for http://bugzilla.sen.cwi.nl:8080/show_bug.cgi?id=841
    ./max-long.patch
  ];

  # There are apparently still some aliasing bugs left in
  # aterm-2.4.2-fixes-r2 (in AT_setAnnotations to be precise), but
  # under my reading of the C standard it should be fine. Anyway, just
  # disable strict aliasing.
  NIX_CFLAGS_COMPILE = "-fno-strict-aliasing";
  
  doCheck = true;

  meta = {
    homepage = http://www.cwi.nl/htbin/sen1/twiki/bin/view/SEN1/ATerm;
    license = "LGPL";
    description = "Library for manipulation of term data structures in C";
  };
}
