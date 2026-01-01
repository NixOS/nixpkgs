{
  lib,
  stdenv,
  fetchFromGitLab,
  extra-cmake-modules,
  qtbase,
  qtdeclarative,
}:

stdenv.mkDerivation rec {
  pname = "kquickimageeditor";
  version = "0.3.0";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "libraries";
    repo = "kquickimageeditor";
    rev = "v${version}";
    sha256 = "sha256-+BByt07HMb4u6j9bVZqkUPvyRaElKvJ2MjKlPakL87E=";
  };

  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [
    qtbase
    qtdeclarative
  ];
  cmakeFlags = [ "-DQT_MAJOR_VERSION=${lib.versions.major qtbase.version}" ];
  dontWrapQtApps = true;

<<<<<<< HEAD
  meta = {
    description = "Set of QtQuick components providing basic image editing capabilities";
    homepage = "https://invent.kde.org/libraries/kquickimageeditor";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.unix;
    badPlatforms = lib.platforms.darwin;
=======
  meta = with lib; {
    description = "Set of QtQuick components providing basic image editing capabilities";
    homepage = "https://invent.kde.org/libraries/kquickimageeditor";
    license = licenses.lgpl21Plus;
    platforms = platforms.unix;
    badPlatforms = platforms.darwin;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
