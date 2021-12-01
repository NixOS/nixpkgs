{ lib, stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "range-v3";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "ericniebler";
    repo = "range-v3";
    rev = version;
    sha256 = "18230bg4rq9pmm5f8f65j444jpq56rld4fhmpham8q3vr1c1bdjh";
  };

  patches = [
    ./gcc10.patch
  ];

  nativeBuildInputs = [ cmake ];

  # Building the tests currently fails on AArch64 due to internal compiler
  # errors (with GCC 9.2):
  cmakeFlags = lib.optional stdenv.isAarch64 "-DRANGE_V3_TESTS=OFF";

  doCheck = !stdenv.isAarch64;
  checkTarget = "test";

  meta = with lib; {
    description = "Experimental range library for C++11/14/17";
    homepage = "https://github.com/ericniebler/range-v3";
    changelog = "https://github.com/ericniebler/range-v3/releases/tag/${version}";
    license = licenses.boost;
    platforms = platforms.all;
    maintainers = with maintainers; [ primeos ];
  };
}
