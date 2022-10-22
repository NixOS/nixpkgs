{ lib
, mkDerivation
, fetchFromGitLab
, extra-cmake-modules
}:

mkDerivation rec {
  pname = "kquickimageeditor";
  version = "0.2.0";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "libraries";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-g7+BAWjpQBJPbrwnIwSudjBFtwaj4JKemV+BLfPzl4I=";
  };

  nativeBuildInputs = [ extra-cmake-modules ];

  meta = with lib; {
    description = "Set of QtQuick components providing basic image editing capabilities";
    homepage = "https://invent.kde.org/libraries/kquickimageeditor";
    license = licenses.lgpl21Plus;
    platforms = platforms.unix;
    badPlatforms = platforms.darwin;
  };
}
