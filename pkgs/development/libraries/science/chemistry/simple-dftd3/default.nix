{
  stdenv,
  lib,
  fetchFromGitHub,
  gfortran,
  meson,
  ninja,
  pkg-config,
  mctc-lib,
  mstore,
  toml-f,
  blas,
}:

assert !blas.isILP64;

stdenv.mkDerivation rec {
  pname = "simple-dftd3";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "dftd3";
    repo = pname;
    tag = "v${version}";
    hash = "sha256-c4xctcMcPQ70ippqbwtinygmnZ5en6ZGF5/v0ZWtzys=";
  };

  nativeBuildInputs = [
    gfortran
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    mctc-lib
    mstore
    toml-f
    blas
  ];

  outputs = [
    "out"
    "dev"
  ];

  doCheck = true;
  preCheck = ''
    export OMP_NUM_THREADS=2
  '';

  meta = {
    description = "Reimplementation of the DFT-D3 program";
    mainProgram = "s-dftd3";
    license = with lib.licenses; [
      lgpl3Only
      gpl3Only
    ];
    homepage = "https://github.com/dftd3/simple-dftd3";
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.sheepforce ];
  };
}
