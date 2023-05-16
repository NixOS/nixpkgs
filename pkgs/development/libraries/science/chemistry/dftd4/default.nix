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
<<<<<<< HEAD
  version = "3.6.0";
=======
  version = "3.5.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "dftd4";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-VIV9953hx0MZupOARdH+P1h7JtZeJmTlqtO8si+lwdU=";
=======
    hash = "sha256-ZCoFbjTNQD7slq5sKwPRPkrHSHofsxU9C9h/bF5jmZI=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
