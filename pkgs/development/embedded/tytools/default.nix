{ lib, stdenv, fetchFromGitHub, cmake, pkg-config, wrapQtAppsHook , qtbase}:

stdenv.mkDerivation rec {
  pname = "tytools";
  version = "0.9.3";

  src = fetchFromGitHub {
    owner = "Koromix";
    repo = pname;
    rev = "v${version}";
    sha256 = "0ax6j17f5nm0q4sp8sg1412hd48qp7whdy7dd699kwjcm763bl5j";
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
