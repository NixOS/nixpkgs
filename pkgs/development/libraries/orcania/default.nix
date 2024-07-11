{ lib, stdenv, fetchFromGitHub, cmake, check, subunit }:
stdenv.mkDerivation rec {
  pname = "orcania";
  version = "2.3.3";

  src = fetchFromGitHub {
    owner = "babelouest";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Cz3IE5UrfoWjMxQ/+iR1bLsYxf5DVN+7aJqLBcPjduA=";
  };

  nativeBuildInputs = [ cmake ];

  nativeCheckInputs = [ check subunit ];

  cmakeFlags = [ "-DBUILD_ORCANIA_TESTING=on" ];

  doCheck = true;

  meta = with lib; {
    description = "Potluck with different functions for different purposes that can be shared among C programs";
    mainProgram = "base64url";
    homepage = "https://github.com/babelouest/orcania";
    license = licenses.lgpl21;
    maintainers = with maintainers; [ johnazoidberg ];
  };
}
