{ lib
, stdenv
, fetchFromGitHub
, pkg-config

, gtk3
, curl
, libxml2
}:

stdenv.mkDerivation rec {
  pname = "smooth";
  version = "0.9.9";

  src = fetchFromGitHub {
    owner = "enzo1982";
    repo = "smooth";
    rev = "v${version}";
    sha256 = "sha256-30qVXK54SDL2+ZPbTINZix4Ax1iOMg2WLeEDyAr77Og=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  makeFlags = [
    "prefix=$(out)"
  ];

  buildInputs = [
    gtk3
    curl
    libxml2
  ];

  meta = with lib; {
    description = "The smooth Class Library";
    license = licenses.artistic2;
    homepage = "http://www.smooth-project.org/";
    maintainers = with maintainers; [ shamilton ];
    platforms = platforms.linux;
  };
}
