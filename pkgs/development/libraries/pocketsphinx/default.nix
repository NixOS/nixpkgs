{ stdenv, fetchurl, sphinxbase, pkgconfig }:

stdenv.mkDerivation rec {
  name = "pocketsphinx-0.8";

  src = fetchurl {
    url = "mirror://sourceforge/cmusphinx/${name}.tar.gz";
    sha256 = "0ynf5ik4ib2d3ha3r4i8ywpr2dz5i6v51hmfl8kgzj4i7l44qk47";
  };

  propagatedBuildInputs = [ sphinxbase ];

  buildInputs = [ pkgconfig ];

  meta = {
    description = "Voice recognition library written in C";
    homepage = http://cmusphinx.sourceforge.net;
    license = stdenv.lib.licenses.free;
    platforms = stdenv.lib.platforms.linux;
  };
}
