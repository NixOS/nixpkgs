{ stdenv, antlr3_4, libantlr3c, jre, mbedtls, fetchFromGitHub
  , cmake, zlib, bctoolbox
}:

stdenv.mkDerivation rec {
  pname = "belle-sip";
  version = "1.6.3";

  src = fetchFromGitHub {
    owner = "BelledonneCommunications";
    repo = pname;
    rev = version;
    sha256 = "0q70db1klvhca1af29bm9paka3gyii5hfbzrj4178gclsg7cj8fk";
  };

  nativeBuildInputs = [ jre cmake ];

  buildInputs = [ zlib ];

  NIX_CFLAGS_COMPILE = toString [
    "-Wno-error=deprecated-declarations"
    "-Wno-error=format-truncation"
    "-Wno-error=cast-function-type"
  ];

  propagatedBuildInputs = [ antlr3_4 libantlr3c mbedtls bctoolbox ];

  # Fails to build with lots of parallel jobs
  enableParallelBuilding = false;

  meta = with stdenv.lib; {
    homepage = https://linphone.org/technical-corner/belle-sip;
    description = "Modern library implementing SIP (RFC 3261) transport, transaction and dialog layers";
    license = licenses.gpl2;
    platforms = platforms.all;
  };
}
