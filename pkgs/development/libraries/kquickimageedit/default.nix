{
  lib,
  stdenv,
  fetchFromGitLab,
  qtbase,
  qtdeclarative,
  kdePackages,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kquickimageeditor";
  version = "0.5.1";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "libraries";
    repo = "kquickimageeditor";
    tag = "v${finalAttrs.version}";
    hash = "sha256-8TJBg42E9lNbLpihjtc5Z/drmmSGQmic8yO45yxSNQ4=";
  };

  nativeBuildInputs = [ kdePackages.extra-cmake-modules ];

  buildInputs = [
    qtbase
    qtdeclarative
  ];

  cmakeFlags = [ "-DQT_MAJOR_VERSION=${lib.versions.major qtbase.version}" ];

  dontWrapQtApps = true;

  meta = {
    description = "Set of QtQuick components providing basic image editing capabilities";
    homepage = "https://invent.kde.org/libraries/kquickimageeditor";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.unix;
    badPlatforms = lib.platforms.darwin;
  };
})
