{ mkDerivation
, fetchFromGitLab
, extra-cmake-modules
}:

mkDerivation rec {
  pname = "kquickimageeditor";
  version = "0.1.3";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "libraries";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-p2uOssS5MQSkmppNKOjTxp866Qx1rIB6ZPhcmVvfBxs=";
  };

  nativeBuildInputs = [ extra-cmake-modules ];
}
