{ stdenv, fetchFromGitHub, qmake, qtbase, qttools }:

stdenv.mkDerivation rec {
  pname = "lumina-calculator";
  version = "2019-04-27";

  src = fetchFromGitHub {
    owner = "lumina-desktop";
    repo = pname;
    rev = "ccb792fc713aa7163fffd37fc20c83ffe9ca7523";
    sha256 = "0cdyz94znycsc3qxg5bmg51bwms7586d4ja1bsmj8cb9pd3lv980";
  };
  
  sourceRoot = "source/src-qt5";

  nativeBuildInputs = [ qmake qttools ];

  buildInputs = [ qtbase ];

  qmakeFlags = [
    "CONFIG+=WITH_I18N"
    "LRELEASE=${stdenv.lib.getDev qttools}/bin/lrelease"
  ];

  meta = with stdenv.lib; {
    description = "Scientific calculator for the Lumina Desktop";
    homepage = https://github.com/lumina-desktop/lumina-calculator;
    license = licenses.bsd3;
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}
