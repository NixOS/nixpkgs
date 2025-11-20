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
  version = "0.6.0";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "libraries";
    repo = "kquickimageeditor";
    rev = "v${version}";
    sha256 = "sha256-NhZ9aAZuIk9vUL2X7eivNbEs0zahuQpy8kl6dSdy5Lo=";
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
