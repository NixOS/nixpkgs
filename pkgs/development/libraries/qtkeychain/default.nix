{ stdenv, fetchFromGitHub, cmake, qt4 ? null
, withQt5 ? false, qtbase ? null, qttools ? null
}:

assert withQt5 -> qtbase != null;
assert withQt5 -> qttools != null;

stdenv.mkDerivation rec {
  name = "qtkeychain-${if withQt5 then "qt5" else "qt4"}-${version}";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "frankosterfeld";
    repo = "qtkeychain";
    rev = "v${version}";
    sha256 = "1r6qp9l2lp5jpc6ciklbg1swvvzcpc37rg9py46hk0wxy6klnm0b";
  };

  cmakeFlags = [ "-DQT_TRANSLATIONS_DIR=share/qt/translations" ];

  nativeBuildInputs = [ cmake ];

  buildInputs = if withQt5 then [ qtbase qttools ] else [ qt4 ];

  meta = {
    description = "Platform-independent Qt API for storing passwords securely";
    homepage = https://github.com/frankosterfeld/qtkeychain;
    license = stdenv.lib.licenses.bsd3;
    platforms = stdenv.lib.platforms.linux;
  };
}
