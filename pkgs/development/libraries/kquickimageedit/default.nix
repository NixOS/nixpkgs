{
  lib,
  stdenv,
  fetchFromGitLab,
  extra-cmake-modules,
  kdePackages,
  qtbase,
  qtdeclarative,
}:

stdenv.mkDerivation rec {
  pname = "kquickimageeditor";
  version = "0.5.1";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "libraries";
    repo = "kquickimageeditor";
    rev = "v${version}";
    sha256 = "sha256-8TJBg42E9lNbLpihjtc5Z/drmmSGQmic8yO45yxSNQ4=";
  };

  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [
    kdePackages.kirigami
    qtbase
    qtdeclarative
  ];
  dontWrapQtApps = true;

  meta = with lib; {
    description = "Set of QtQuick components providing basic image editing capabilities";
    homepage = "https://invent.kde.org/libraries/kquickimageeditor";
    license = licenses.lgpl21Plus;
    platforms = platforms.unix;
    badPlatforms = platforms.darwin;
  };
}
