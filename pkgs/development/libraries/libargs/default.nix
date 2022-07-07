{ lib, stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "args";
  version = "6.3.0";

  src = fetchFromGitHub {
    owner = "Taywee";
    repo = pname;
    rev = version;
    sha256 = "sha256-fEM9KNqqxYbafMcHCW46Y//8Hrvd7gZrCIQhH5lhpFc=";
  };

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "A simple header-only C++ argument parser library";
    homepage = "https://github.com/Taywee/args";
    license = licenses.mit;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
