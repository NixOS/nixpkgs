{ lib, mkDerivation, fetchFromGitHub, qmake, qtbase, qttools }:

mkDerivation rec {
  pname = "lumina-calculator";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "lumina-desktop";
    repo = pname;
    rev = "v${version}";
    sha256 = "1238d1m0mjkwkdpgq165a4ql9aql0aji5f41rzdzny6m7ws9nm2y";
  };

<<<<<<< HEAD
  sourceRoot = "${src.name}/src-qt5";
=======
  sourceRoot = "source/src-qt5";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  nativeBuildInputs = [ qmake qttools ];

  buildInputs = [ qtbase ];

  qmakeFlags = [
    "CONFIG+=WITH_I18N"
    "LRELEASE=${lib.getDev qttools}/bin/lrelease"
  ];

  meta = with lib; {
    description = "Scientific calculator for the Lumina Desktop";
    homepage = "https://github.com/lumina-desktop/lumina-calculator";
    license = licenses.bsd3;
    platforms = platforms.unix;
    maintainers = teams.lumina.members;
  };
}
