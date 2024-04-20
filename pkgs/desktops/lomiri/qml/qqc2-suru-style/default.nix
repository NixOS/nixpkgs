{ stdenv
, lib
, fetchFromGitLab
, gitUpdater
, qmake
, qtdeclarative
, qtquickcontrols2
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "qqc2-suru-style";
  version = "0.20230206";

  src = fetchFromGitLab {
    owner = "ubports";
    repo = "development/core/qqc2-suru-style";
    rev = finalAttrs.version;
    hash = "sha256-ZLPuXnhlR1IDhGnprcdWHLnOeS6ZzVkFhQML0iKMjO8=";
  };

  # QMake can't find Qt modules from buildInputs
  strictDeps = false;

  nativeBuildInputs = [
    qmake
  ];

  buildInputs = [
    qtdeclarative
    qtquickcontrols2
  ];

  dontWrapQtApps = true;

  passthru.updateScript = gitUpdater { };

  meta = with lib; {
    description = "Suru Style for QtQuick Controls 2";
    homepage = "https://gitlab.com/ubports/development/core/qqc2-suru-style";
    changelog = "https://gitlab.com/ubports/development/core/qqc2-suru-style/-/blob/${finalAttrs.version}/ChangeLog";
    license = with licenses; [ gpl2Plus lgpl3Only cc-by-sa-30 ];
    maintainers = teams.lomiri.members;
    platforms = platforms.unix;
  };
})
