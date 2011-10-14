{stdenv, fetchurl, cmake, ruby}:

stdenv.mkDerivation {
  name = "yajl-2.0.1";

  src = fetchurl {
    url = http://github.com/lloyd/yajl/tarball/2.0.1;
    name = "yajl-2.0.1.tar.gz";
    sha256 = "08a7bgmdpvi6w9f9bxx5f42njwmwzdf6jz3w6ila7jgbl5mhknf2";
  };

  buildInputs = [ cmake ruby ];

  meta = {
    description = "Yet Another JSON Library";
    longDescription = ''
      YAJL is a small event-driven (SAX-style) JSON parser written in ANSI
      C, and a small validating JSON generator.
    '';
    homepage = http://lloyd.github.com/yajl/;
    license = stdenv.lib.license.isc;
  };
}
