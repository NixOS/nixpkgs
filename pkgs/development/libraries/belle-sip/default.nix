{ stdenv, antlr3_4, libantlr3c, jre, polarssl, fetchFromGitHub
  , cmake, zlib, bctoolbox
}:

stdenv.mkDerivation rec {
  baseName = "belle-sip";
  version = "1.6.3";
  name = "${baseName}-${version}";

  src = fetchFromGitHub {
    owner = "BelledonneCommunications";
    repo = "${baseName}";
    rev = "${version}";
    sha256 = "0q70db1klvhca1af29bm9paka3gyii5hfbzrj4178gclsg7cj8fk";
  };

  nativeBuildInputs = [ jre cmake ];

  buildInputs = [ zlib ];

  NIX_CFLAGS_COMPILE = "-Wno-error=deprecated-declarations";

  propagatedBuildInputs = [ antlr3_4 libantlr3c polarssl bctoolbox ];

  configureFlags = [
    "--with-polarssl=${polarssl}"
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = http://www.linphone.org/index.php/eng;
    description = "A Voice-over-IP phone";
    license = licenses.gpl2;
    platforms = platforms.all;
  };
}
