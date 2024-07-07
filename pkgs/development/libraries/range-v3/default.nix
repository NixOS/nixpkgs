{ lib, stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "range-v3";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "ericniebler";
    repo = "range-v3";
    rev = version;
    hash = "sha256-bRSX91+ROqG1C3nB9HSQaKgLzOHEFy9mrD2WW3PRBWU=";
  };

  nativeBuildInputs = [ cmake ];

  # Building the tests currently fails on AArch64 due to internal compiler
  # errors (with GCC 9.2):
  cmakeFlags = [ "-DRANGES_ENABLE_WERROR=OFF" ]
    ++ lib.optional stdenv.isAarch64 "-DRANGE_V3_TESTS=OFF";

  doCheck = !stdenv.isAarch64;
  checkTarget = "test";

  meta = with lib; {
    description = "Experimental range library for C++11/14/17";
    homepage = "https://github.com/ericniebler/range-v3";
    changelog = "https://github.com/ericniebler/range-v3/releases/tag/${version}";
    license = licenses.boost;
    platforms = platforms.all;
    maintainers = with maintainers; [ ];
  };
}
