{ lib, stdenv, fetchFromGitHub, cmake, pkg-config, wrapQtAppsHook , qtbase}:

stdenv.mkDerivation rec {
  pname = "tytools";
  version = "0.9.7";

  src = fetchFromGitHub {
    owner = "Koromix";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-iF2XyWSBBCO23iY/ni+QlpgtOuWKN2JTMTz+9OLEadk=";
  };

  nativeBuildInputs = [ cmake pkg-config wrapQtAppsHook ];
  buildInputs = [
    qtbase
  ];

  meta = with lib; {
    description = "Collection of tools to manage Teensy boards";
    homepage = "https://koromix.dev/tytools";
    license = licenses.unlicense;
    platforms = platforms.unix;
    maintainers = with maintainers; [ ahuzik ];
  };
}
