{ stdenv, fetchurl, pkgconfig, curl, openssl }:

stdenv.mkDerivation rec {
  name = "liblastfm-SF-0.3.2";

  buildInputs = [ pkgconfig ];

  propagatedBuildInputs = [ curl openssl ];

  src = fetchurl {
    url = "mirror://sourceforge/liblastfm/liblastfm-0.3.2.tar.gz";
    sha256 = "1hk62giysi96h6cyjyph69nlv1v4vw45w3sx7i2m89i9aysd6qp7";
  };

  meta = {
    homepage = http://liblastfm.sourceforge.net;
    description = "Unofficial C lastfm library";
  };
}
