{ stdenv, fetchurl, bison, pkgconfig }:

stdenv.mkDerivation rec {
  name = "sphinxbase-0.7";

  src = fetchurl {
    url = "mirror://sourceforge/cmusphinx/${name}.tar.gz";
    sha256 = "1v3kfzw42ahxmr002i6wqigs832958vgghrv5dd62zazajdbk71q";
  };

  buildInputs = [ pkgconfig bison ];

  meta = {
    description = "Support Library for Pocketsphinx";
    homepage = http://cmusphinx.sourceforge.net;
    license = "free-non-copyleft";
    maintainers = [ stdenv.lib.maintainers.shlevy ];
  };
}
