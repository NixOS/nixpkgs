{ stdenv
, lib
, fetchFromGitHub
, gfortran
, blas
, cmake
, lapack
, which
}:

stdenv.mkDerivation rec {
  pname = "qrupdate";
  version = "1.1.5";

  src = fetchFromGitHub {
    owner = "mpimd-csc";
    repo = "qrupdate-ng";
    rev = "v${version}";
    hash = "sha256-dHxLPrN00wwozagY2JyfZkD3sKUD2+BcnbjNgZepzFg=";
  };

  cmakeFlags = assert (blas.isILP64 == lapack.isILP64); [
    "-DCMAKE_Fortran_FLAGS=${toString ([
      "-std=legacy"
    ] ++ lib.optionals blas.isILP64 [
      # If another application intends to use qrupdate compiled with blas with
      # 64 bit support, it should add this to it's FFLAGS as well. See (e.g):
      # https://savannah.gnu.org/bugs/?50339
      "-fdefault-integer-8"
    ])}"
  ];

  doCheck = true;

  nativeBuildInputs = [
    cmake
    which
    gfortran
  ];
  buildInputs = [
    blas
    lapack
  ];

  meta = with lib; {
    description = "Library for fast updating of qr and cholesky decompositions";
    homepage = "https://github.com/mpimd-csc/qrupdate-ng";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ doronbehar ];
    platforms = platforms.unix;
  };
}
