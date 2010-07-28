{ stdenv, fetchurl, autoconf, automake, libtool }:

stdenv.mkDerivation {
  name = "faac-1.26";

  src = fetchurl {
    url = http://downloads.sourceforge.net/faac/faac-1.26.tar.gz;
    sha256 = "0ld9d8mn3yp90japzkqkicmjcggi7d8y9gn7cl1jdsb74bif4j2b";
  };

  preConfigure = "./bootstrap";

  buildInputs = [ autoconf automake libtool ];

  meta = {
    description = "Open source MPEG-4 and MPEG-2 AAC encoder";
    homepage = http://www.audiocoding.com/faac.html;
    license = "LGPL";
  };
}
