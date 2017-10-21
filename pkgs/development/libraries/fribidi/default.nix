{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "fribidi-${version}";
  version = "0.19.7";

  src = fetchurl {
    url = "http://fribidi.org/download/${name}.tar.bz2";
    sha256 = "13jsb5qadlhsaxkbrb49nqslmbh904vvzhsm5mm2ghmv29i2l8h8";
  };

  hardeningDisable = [ "format" ];

  outputs = [ "out" "devdoc" ];

  meta = with stdenv.lib; {
    homepage = http://fribidi.org/;
    description = "GNU implementation of the Unicode Bidirectional Algorithm (bidi)";
    license = licenses.gpl2;
    platforms = platforms.unix;
  };
}
