{stdenv, fetchurl, cmake, ruby, darwinInstallNameToolUtility}:

stdenv.mkDerivation {
  name = "yajl-2.0.1";

  src = fetchurl {
    url = http://github.com/lloyd/yajl/tarball/2.0.1;
    name = "yajl-2.0.1.tar.gz";
    sha256 = "08a7bgmdpvi6w9f9bxx5f42njwmwzdf6jz3w6ila7jgbl5mhknf2";
  };

  buildInputs = [ cmake ruby ]
    ++ stdenv.lib.optional stdenv.isDarwin darwinInstallNameToolUtility;

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
