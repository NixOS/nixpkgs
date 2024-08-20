{ stdenv
, lib
, fetchFromGitHub
, gfortran
, meson
, ninja
, pkg-config
, mctc-lib
, mstore
, toml-f
, blas
}:

assert !blas.isILP64;

stdenv.mkDerivation rec {
  pname = "simple-dftd3";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "dftd3";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-XeLf5v/GraDGcTsVIEBnS4AL8tMeO11YTuPHlNt5Ap8=";
  };

  nativeBuildInputs = [ gfortran meson ninja pkg-config ];

  buildInputs = [ mctc-lib mstore toml-f blas ];

  outputs = [ "out" "dev" ];

  doCheck = true;
  preCheck = ''
    export OMP_NUM_THREADS=2
  '';

  meta = with lib; {
    description = "Reimplementation of the DFT-D3 program";
    mainProgram = "s-dftd3";
    license = with licenses; [ lgpl3Only gpl3Only ];
    homepage = "https://github.com/dftd3/simple-dftd3";
    platforms = platforms.linux;
    maintainers = [ maintainers.sheepforce ];
  };
}
