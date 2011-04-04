{ stdenv, fetchurl, sphinxbase, pkgconfig }:

stdenv.mkDerivation rec {
  name = "pocketsphinx-0.6.1";

  src = fetchurl {
    url = "mirror://sourceforge/cmusphinx/${name}.tar.gz";
    sha256 = "1nnw7p3inplsgx0dkvgllri2bfzry2dd7mc9q4l47p11z2jflvvv";
  };

  propagatedBuildInputs = [ sphinxbase ];

  buildInputs = [ pkgconfig ];

  meta = {
    description = "Voice recognition library written in C";
    homepage = http://cmusphinx.sourceforge.net;
    license = "free-non-copyleft";
    maintainers = [ stdenv.lib.maintainers.shlevy ];
  };
}
