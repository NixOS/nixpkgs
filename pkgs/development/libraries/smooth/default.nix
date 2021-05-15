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
  version = "0.9.6";

  src = fetchFromGitHub {
    owner = "enzo1982";
    repo = "smooth";
    rev = "v${version}";
    sha256 = "05j5gk6kz2089x8bcq2l0kjspfiiymxn69jcxl4dh9lw96blbadr";
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
