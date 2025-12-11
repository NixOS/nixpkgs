{
  stdenv,
  lib,
  fetchFromGitLab,
  gitUpdater,
  qmake,
  qtdeclarative,
  qtquickcontrols2,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "qqc2-suru-style";
  version = "0.20230630";

  src = fetchFromGitLab {
    owner = "ubports";
    repo = "development/core/qqc2-suru-style";
    rev = "refs/tags/${finalAttrs.version}";
    hash = "sha256-kAgHsNWwUWxHg26bTMmlq8m9DR4+ob4pl/oUX7516hM=";
  };

  # QMake can't find Qt modules from buildInputs
  strictDeps = false;

  nativeBuildInputs = [ qmake ];

  buildInputs = [
    qtdeclarative
    qtquickcontrols2
  ];

  dontWrapQtApps = true;

  passthru.updateScript = gitUpdater { };

  meta = {
    description = "Suru Style for QtQuick Controls 2";
    homepage = "https://gitlab.com/ubports/development/core/qqc2-suru-style";
    changelog = "https://gitlab.com/ubports/development/core/qqc2-suru-style/-/blob/${finalAttrs.version}/ChangeLog";
    license = with lib.licenses; [
      gpl2Plus
      lgpl3Only
      cc-by-sa-30
    ];
    teams = [ lib.teams.lomiri ];
    platforms = lib.platforms.unix;
  };
})
