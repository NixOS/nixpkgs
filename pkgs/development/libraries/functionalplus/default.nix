{ lib, stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "functionalplus";
  version = "0.2.23";

  src = fetchFromGitHub {
    owner = "Dobiasd";
    repo = "FunctionalPlus";
    rev = "v${version}";
    sha256 = "sha256-WDufVO0vQyu7O3w9tq+19JioRUFgYlnTbO/AQzg0FnM=";
  };

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "Functional Programming Library for C++";
    homepage = "https://github.com/Dobiasd/FunctionalPlus";
    license = licenses.boost;
    platforms = platforms.all;
    maintainers = [];
  };
}
