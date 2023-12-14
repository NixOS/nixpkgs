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
  version = "3.6.0";

  src = fetchFromGitHub {
    owner = "dftd4";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-VIV9953hx0MZupOARdH+P1h7JtZeJmTlqtO8si+lwdU=";
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
