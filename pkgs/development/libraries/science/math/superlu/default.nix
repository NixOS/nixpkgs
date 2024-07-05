{ lib, stdenv, fetchurl, cmake,
  gfortran, blas, lapack}:

assert (!blas.isILP64) && (!lapack.isILP64);

stdenv.mkDerivation rec {
  version = "5.2.1";
  pname = "superlu";

  src = fetchurl {
    url = "http://crd-legacy.lbl.gov/~xiaoye/SuperLU/superlu_${version}.tar.gz";
    sha256 = "0qzlb7cd608q62kyppd0a8c65l03vrwqql6gsm465rky23b6dyr8";
  };

  nativeBuildInputs = [ cmake gfortran ];

  propagatedBuildInputs = [ blas ];

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=true"
    "-DUSE_XSDK_DEFAULTS=true"
  ];

  env = lib.optionalAttrs stdenv.cc.isClang {
    NIX_CFLAGS_COMPILE = toString [
      "-Wno-error=implicit-function-declaration"
      "-Wno-error=implicit-int"
    ];
  };

  patches = [
    ./add-superlu-lib-as-dependency-for-the-unit-tests.patch
  ];

  doCheck = true;
  checkTarget = "test";

  meta = {
    homepage = "http://crd-legacy.lbl.gov/~xiaoye/SuperLU/";
    license = "http://crd-legacy.lbl.gov/~xiaoye/SuperLU/License.txt";
    description = "Library for the solution of large, sparse, nonsymmetric systems of linear equations";
    platforms = lib.platforms.unix;
  };
}
