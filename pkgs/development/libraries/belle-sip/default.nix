{ stdenv, fetchurl, antlr3_4, libantlr3c, jre, polarssl, fetchFromGitHub
  , cmake, zlib, bctoolbox
}:

stdenv.mkDerivation rec {
  baseName = "belle-sip";
  version = "1.5.0";
  name = "${baseName}-${version}";

  src = fetchFromGitHub {
    owner = "BelledonneCommunications";
    repo = "${baseName}";
    rev = "${version}";
    sha256 = "0hnm64hwgq003wicz6c485fryjfhi820fgin8ndknq60kvwxsrzn";
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
