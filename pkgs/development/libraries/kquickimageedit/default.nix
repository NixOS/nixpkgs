{ lib
, stdenv
, fetchFromGitLab
, extra-cmake-modules
, qtbase
, qtdeclarative
}:

stdenv.mkDerivation rec {
  pname = "kquickimageeditor";
  version = "0.3.0";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "libraries";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-+BByt07HMb4u6j9bVZqkUPvyRaElKvJ2MjKlPakL87E=";
  };

  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ qtbase qtdeclarative ];
  cmakeFlags = ["-DQT_MAJOR_VERSION=${lib.versions.major qtbase.version}"];
  dontWrapQtApps = true;

  meta = with lib; {
    description = "Set of QtQuick components providing basic image editing capabilities";
    homepage = "https://invent.kde.org/libraries/kquickimageeditor";
    license = licenses.lgpl21Plus;
    platforms = platforms.unix;
    badPlatforms = platforms.darwin;
  };
}
