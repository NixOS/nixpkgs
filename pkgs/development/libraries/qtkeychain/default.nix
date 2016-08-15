{ stdenv, fetchFromGitHub, cmake, qt4 }:

stdenv.mkDerivation rec {
  name = "qtkeychain-${version}";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "frankosterfeld";
    repo = "qtkeychain";
    rev = "v${version}";
    sha256 = "10msaylisbwmgpwd59vr4dfgml75kji8mlfwnwq8yp29jikj5amq";
  };

  cmakeFlags = [ "-DQT_TRANSLATIONS_DIR=$out/share/qt/translations" ];

  buildInputs = [ cmake qt4 ];

  meta = {
    description = "Platform-independent Qt API for storing passwords securely";
    homepage = "https://github.com/frankosterfeld/qtkeychain";
    license = stdenv.lib.licenses.bsd3;
    platforms = stdenv.lib.platforms.linux;
  };
}
