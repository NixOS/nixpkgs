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
  version = "0.9.8";

  src = fetchFromGitHub {
    owner = "enzo1982";
    repo = "smooth";
    rev = "v${version}";
    sha256 = "sha256-4092Od/wCWe4br80Ry6mr8GpUIUeeF6sk3unELdfQJU=";
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
