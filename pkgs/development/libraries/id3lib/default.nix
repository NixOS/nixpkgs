{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "id3lib-3.8.3";

  patches = [ ./id3lib-3.8.3-gcc43-1.patch ];
  
  src = fetchurl {
    url = mirror://sourceforge/id3lib/id3lib-3.8.3.tar.gz;
    md5 = "19f27ddd2dda4b2d26a559a4f0f402a7";
  };
}
