{ stdenv
, lib
, fetchFromGitHub
, cmake
, gfortran
, blas
, lapack
, mctc-lib
, mstore
, multicharge
}:

assert !blas.isILP64 && !lapack.isILP64;

stdenv.mkDerivation rec {
  pname = "dftd4";
  version = "3.5.0";

  src = fetchFromGitHub {
    owner = "dftd4";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-ZCoFbjTNQD7slq5sKwPRPkrHSHofsxU9C9h/bF5jmZI=";
  };

  nativeBuildInputs = [ cmake gfortran ];

  buildInputs = [ blas lapack mctc-lib mstore multicharge ];

  postInstall = ''
    substituteInPlace $out/lib/pkgconfig/${pname}.pc \
      --replace "''${prefix}/" ""
  '';

  doCheck = true;
  preCheck = ''
    export OMP_NUM_THREADS=2
  '';

  meta = with lib; {
    description = "Generally Applicable Atomic-Charge Dependent London Dispersion Correction";
    license = with licenses; [ lgpl3Plus gpl3Plus ];
    homepage = "https://github.com/grimme-lab/dftd4";
    platforms = platforms.linux;
    maintainers = [ maintainers.sheepforce ];
  };
}
