{
  lib,
  stdenv,
  fetchFromGitLab,
  cmake,
  doxygen,
  graphviz,
  arpa2common,
  arpa2cm,
}:

stdenv.mkDerivation rec {
  pname = "quickmem";
  version = "0.3.0";

  src = fetchFromGitLab {
    owner = "arpa2";
    repo = "Quick-MEM";
    rev = "v${version}";
    sha256 = "sha256-cqg8QN4/I+zql7lVDDAgFA05Dmg4ylBTvPSPP7WATdc=";
  };

  nativeBuildInputs = [
    cmake
    doxygen
    graphviz
  ];

  buildInputs = [
    arpa2cm
    arpa2common
  ];

  doCheck = true;

  meta = with lib; {
    description = "Memory pooling for ARPA2 projects";
    homepage = "https://gitlab.com/arpa2/Quick-MEM/";
    license = licenses.bsd2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ leungbk ];
  };
}
