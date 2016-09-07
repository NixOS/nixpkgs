{ stdenv, fetchFromGitHub, cmake, qt4 }:

stdenv.mkDerivation rec {
  name = "qtkeychain-${version}";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "frankosterfeld";
    repo = "qtkeychain";
    rev = "v${version}";
    sha256 = "04v6ymkw7qd1pf9lwijgqrl89w2hhsnqgz7dm4cdrh8i8dffpn52";
  };

  cmakeFlags = [ "-DQT_TRANSLATIONS_DIR=share/qt/translations" ];

  buildInputs = [ cmake qt4 ];

  meta = {
    description = "Platform-independent Qt API for storing passwords securely";
    homepage = "https://github.com/frankosterfeld/qtkeychain";
    license = stdenv.lib.licenses.bsd3;
    platforms = stdenv.lib.platforms.linux;
  };
}
