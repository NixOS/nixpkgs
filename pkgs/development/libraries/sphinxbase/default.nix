{ stdenv, fetchurl, pkgconfig }:

stdenv.mkDerivation rec {
  name = "sphinxbase-0.6.1";

  src = fetchurl {
    url = "mirror://sourceforge/cmusphinx/${name}.tar.gz";
    sha256 = "1blra8igkqbqr7m2izbis1h3kkzblsqj9rkbw0f00025li8i1z55";
  };

  buildInputs = [ pkgconfig ];

  meta = {
    description = "Support Library for Pocketsphinx";
    homepage = http://cmusphinx.sourceforge.net;
    license = "free-non-copyleft";
    maintainers = [ stdenv.lib.maintainers.shlevy ];
  };
}
