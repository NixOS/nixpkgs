{ stdenv, fetchurl, cmake, ruby }:

stdenv.mkDerivation {
  name = "yajl-2.0.4";

  src = fetchurl {
    url = http://github.com/lloyd/yajl/tarball/2.0.4;
    name = "yajl-2.0.1.tar.gz";
    sha256 = "0661bfi4hfvwg3z2pf51wqbf5qd5kfn0dk83v5s2xwhmry8rd6y1";
  };

  buildInputs = [ cmake ruby ];

  meta = {
    description = "Yet Another JSON Library";
    longDescription = ''
      YAJL is a small event-driven (SAX-style) JSON parser written in ANSI
      C, and a small validating JSON generator.
    '';
    homepage = http://lloyd.github.com/yajl/;
    license = stdenv.lib.licenses.isc;
    platforms = with stdenv.lib.platforms; linux ++ darwin;
    maintainers = with stdenv.lib.maintainers; [ z77z ];
  };
}
