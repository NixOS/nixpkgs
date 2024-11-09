{ lib
, stdenv
, fetchFromGitHub
, libnl
, ncurses
, pkg-config
}:

stdenv.mkDerivation rec {
  pname = "wavemon";
  version = "0.9.6";

  src = fetchFromGitHub {
    owner = "uoaerg";
    repo = "wavemon";
    rev = "v${version}";
    sha256 = "sha256-OnELXlnzXamQflCAWuc4fxwvqHZtl+nrlTpkKK4IGKw=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    libnl
    ncurses
  ];

  meta = with lib; {
    description = "Ncurses-based monitoring application for wireless network devices";
    homepage = "https://github.com/uoaerg/wavemon";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ raskin fpletz ];
    platforms = platforms.linux;
    mainProgram = "wavemon";
  };
}
