{stdenv, fetchFromGitHub, cmake, mbedtls, bcunit, srtp}:
stdenv.mkDerivation rec {
  name = "${baseName}-${version}";
  baseName = "bctoolbox";
  version = "0.2.0";
  buildInputs = [cmake mbedtls bcunit srtp];
  src = fetchFromGitHub {
    owner = "BelledonneCommunications";
    repo = "${baseName}";
    rev = "${version}";
    sha256 = "09mjqdfjxy4jy1z68b2i99hgkbnhhk7vnbfhj9sdpd1p3jk2ha33";
  };

  meta = {
    inherit version;
    description = ''Utilities library for Linphone'';
    license = stdenv.lib.licenses.gpl2Plus ;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
  };
}
