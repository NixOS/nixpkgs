{ stdenv, fetchurl, bison, pkgconfig }:

stdenv.mkDerivation rec {
  name = "sphinxbase-0.7";

  src = fetchurl {
    url = "mirror://sourceforge/cmusphinx/${name}.tar.gz";
    sha256 = "0xab4ph9215rw5865gihmahbbnbi58klll5xg0il9ifld4wdjacq";
  };

  buildInputs = [ pkgconfig bison ];

  meta = {
    description = "Support Library for Pocketsphinx";
    homepage = http://cmusphinx.sourceforge.net;
    license = "free-non-copyleft";
    maintainers = [ stdenv.lib.maintainers.shlevy ];
  };
}
