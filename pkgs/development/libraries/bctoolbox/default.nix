{stdenv, fetchFromGitHub, cmake, mbedtls, bcunit, srtp}:
stdenv.mkDerivation rec {
  name = "${baseName}-${version}";
  baseName = "bctoolbox";
  version = "0.6.0";
  buildInputs = [cmake mbedtls bcunit srtp];
  src = fetchFromGitHub {
    owner = "BelledonneCommunications";
    repo = baseName;
    rev = version;
    sha256 = "1cxx243wyzkd4xnvpyqf97n0rjhfckpvw1vhwnbwshq3q6fra909";
  };

  meta = {
    inherit version;
    description = ''Utilities library for Linphone'';
    license = stdenv.lib.licenses.gpl2Plus ;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
  };
}
