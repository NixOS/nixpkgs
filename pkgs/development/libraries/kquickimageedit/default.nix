{ mkDerivation
, fetchFromGitLab
, extra-cmake-modules
}:

mkDerivation rec {
  pname = "kquickimageeditor";
  version = "0.1.2";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "libraries";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-4X3GO/NPzA3c9KiGIkznLHUjLfNNNnPXif7IFwY5dOM=";
  };

  nativeBuildInputs = [ extra-cmake-modules ];
}
