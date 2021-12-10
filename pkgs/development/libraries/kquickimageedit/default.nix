{ mkDerivation
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
}
