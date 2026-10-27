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
    hash = "sha256-XlSbND/VePvbz4G4EqUCFKtEMVHFBPxum3zKCmpoaIg=";
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

  meta = {
    description = "Scientific calculator for the Lumina Desktop";
    mainProgram = "lumina-calculator";
    homepage = "https://github.com/lumina-desktop/lumina-calculator";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
    teams = [ lib.teams.lumina ];
  };
}
