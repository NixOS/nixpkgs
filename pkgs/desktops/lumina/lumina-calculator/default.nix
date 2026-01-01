{
  lib,
  mkDerivation,
  fetchFromGitHub,
  qmake,
  qtbase,
  qttools,
}:

mkDerivation rec {
  pname = "lumina-calculator";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "lumina-desktop";
    repo = "lumina-calculator";
    rev = "v${version}";
    sha256 = "1238d1m0mjkwkdpgq165a4ql9aql0aji5f41rzdzny6m7ws9nm2y";
  };

  sourceRoot = "${src.name}/src-qt5";

  nativeBuildInputs = [
    qmake
    qttools
  ];

  buildInputs = [ qtbase ];

  qmakeFlags = [
    "CONFIG+=WITH_I18N"
    "LRELEASE=${lib.getDev qttools}/bin/lrelease"
  ];

<<<<<<< HEAD
  meta = {
    description = "Scientific calculator for the Lumina Desktop";
    mainProgram = "lumina-calculator";
    homepage = "https://github.com/lumina-desktop/lumina-calculator";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
    teams = [ lib.teams.lumina ];
=======
  meta = with lib; {
    description = "Scientific calculator for the Lumina Desktop";
    mainProgram = "lumina-calculator";
    homepage = "https://github.com/lumina-desktop/lumina-calculator";
    license = licenses.bsd3;
    platforms = platforms.unix;
    teams = [ teams.lumina ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
