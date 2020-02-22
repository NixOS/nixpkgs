{ stdenv, fetchFromGitHub, cmake, bcunit, mbedtls }:

stdenv.mkDerivation rec {
  pname = "bctoolbox";
  version = "0.6.0";

  nativeBuildInputs = [ cmake bcunit ];
  buildInputs = [ mbedtls ];

  src = fetchFromGitHub {
    owner = "BelledonneCommunications";
    repo = pname;
    rev = version;
    sha256 = "1cxx243wyzkd4xnvpyqf97n0rjhfckpvw1vhwnbwshq3q6fra909";
  };

  NIX_CFLAGS_COMPILE = [ "-Wno-error=stringop-truncation" ];

  meta = {
    inherit version;
    description = "Utilities library for Linphone";
    homepage = "https://github.com/BelledonneCommunications/bctoolbox";
    license = stdenv.lib.licenses.gpl2Plus ;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
  };
}
