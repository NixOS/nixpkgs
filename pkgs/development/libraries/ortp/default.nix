{ stdenv, cmake, fetchFromGitHub, bctoolbox }:

stdenv.mkDerivation rec {
  pname = "ortp";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "BelledonneCommunications";
    repo = pname;
    rev = version;
    sha256 = "12cwv593bsdnxs0zfcp07vwyk7ghlz2wv7vdbs1ksv293w3vj2rv";
  };

  NIX_CFLAGS_COMPILE = "-Wno-error=stringop-truncation";

  buildInputs = [ bctoolbox ];
  nativeBuildInputs = [ cmake ];

  meta = with stdenv.lib; {
    description = "A Real-Time Transport Protocol (RFC3550) stack";
    homepage = https://linphone.org/technical-corner/ortp;
    license = licenses.gpl2Plus;
    platforms = platforms.all;
  };
}
