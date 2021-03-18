{
  lib, stdenv,
  fetchFromGitHub,
  fetchpatch,
  gfortran,
  cmake,
  shared ? true
}:
let
  inherit (lib) optional;
  version = "3.9.1-pre";
in

stdenv.mkDerivation rec {
  pname = "liblapack";
  inherit version;

  src = fetchFromGitHub {
    owner = "Reference-LAPACK";
    repo = "lapack";
    rev = "v${version}";
    sha256 = "1ygx9l81h32hrsxqs38c9x392n9bxszzrxg02n4isdx1qi9s9f7b";
  };

  patches = [
    # https://github.com/Reference-LAPACK/lapack/pull/521
    (fetchpatch {
      url = "https://github.com/Reference-LAPACK/lapack/commit/789197e1a50da24ec96276e9ee9254d38cf9d7b0.diff";
      sha256 = "1z107x543f5wpkw6p4cifryzl67i0fnkhalfl3rbb03y5x56pqrc";
    })
    (fetchpatch {
      url = "https://github.com/Reference-LAPACK/lapack/commit/b4123cbc5d7d5d4230b307e8e70c4356882e5597.diff";
      sha256 = "0fyr08qj5532zl5hzbai7pd0inbclr720rbyvmz24p2bkk96yg8m";
    })
  ];

  nativeBuildInputs = [ gfortran cmake ];

  # Configure stage fails on aarch64-darwin otherwise, due to either clang 11 or gfortran 10.
  hardeningDisable = lib.optionals (stdenv.isDarwin && stdenv.isAarch64) [ "stackprotector" ];

  cmakeFlags = [
    "-DCMAKE_Fortran_FLAGS=-fPIC"
    "-DLAPACKE=ON"
    "-DCBLAS=ON"
    "-DBUILD_TESTING=ON"
  ]
  ++ optional shared "-DBUILD_SHARED_LIBS=ON";

  doCheck = true;

  meta = with lib; {
    inherit version;
    description = "Linear Algebra PACKage";
    homepage = "http://www.netlib.org/lapack/";
    license = licenses.bsd3;
    platforms = platforms.all;
  };
}
