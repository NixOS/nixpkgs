{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "fribidi-${version}";
  version = "0.19.6";

  src = fetchurl {
    url = "http://fribidi.org/download/${name}.tar.bz2";
    sha256 = "0zg1hpaml34ny74fif97j7ngrshlkl3wk3nja3gmlzl17i1bga6b";
  };

  hardeningDisable = [ "format" ];

  meta = with stdenv.lib; {
    homepage = http://fribidi.org/;
    description = "GNU implementation of the Unicode Bidirectional Algorithm (bidi)";
    license = licenses.gpl2;
    platforms = platforms.unix;
  };
}
