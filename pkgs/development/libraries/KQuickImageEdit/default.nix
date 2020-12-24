{ stdenv
, fetchFromGitLab
, extra-cmake-modules
, qtbase
, qtquickcontrols2
}:

stdenv.mkDerivation rec {
  pname = "KQuickImageEditor";
  version = "0.1";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "libraries";
    repo = pname;
    rev = version;
    sha256 = "0krx9bq6nfmpjjangis8gaz8rx3z35f6m3cpsrcfdwpgpm22fqll";
  };

  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ qtbase qtquickcontrols2 ];
}
