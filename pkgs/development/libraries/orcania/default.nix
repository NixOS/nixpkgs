{ lib, stdenv, fetchpatch, fetchFromGitHub, cmake, check, subunit }:
stdenv.mkDerivation rec {
  pname = "orcania";
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "babelouest";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-QAq/6MGVj+iBHLElHuqokF1v3LU1TZ9hVVJE1s3y6f0=";
  };

  # in master post 2.2.2, see https://github.com/babelouest/orcania/issues/27
  patches = [
    (fetchpatch {
      name = "fix-pkg-config.patch";
      url = "https://github.com/babelouest/orcania/commit/4eac7d5ff76bb3bec8250fef300b723c8891552a.patch";
      sha256 = "01bsxay1ca8d08ac3ddcqyvjwgz5mgs68jz5y3gzq4qnzl3q1i54";
    })
  ];

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
