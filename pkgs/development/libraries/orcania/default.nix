{ lib, stdenv, fetchFromGitHub, cmake, check, subunit }:
stdenv.mkDerivation rec {
  pname = "orcania";
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "babelouest";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-QAq/6MGVj+iBHLElHuqokF1v3LU1TZ9hVVJE1s3y6f0=";
  };

  nativeBuildInputs = [ cmake ];

  checkInputs = [ check subunit ];

  cmakeFlags = [ "-DBUILD_ORCANIA_TESTING=on" ];

  doCheck = true;

  meta = with lib; {
    description = "Potluck with different functions for different purposes that can be shared among C programs";
    homepage = "https://github.com/babelouest/orcania";
    license = licenses.lgpl21;
    maintainers = with maintainers; [ johnazoidberg ];
  };
}
