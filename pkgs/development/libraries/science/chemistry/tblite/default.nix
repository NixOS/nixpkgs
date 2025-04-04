{
  stdenv,
  lib,
  fetchFromGitHub,
  gfortran,
  meson,
  ninja,
  pkg-config,
  blas,
  lapack,
  mctc-lib,
  mstore,
  toml-f,
  multicharge,
  dftd4,
  simple-dftd3,
}:

assert !blas.isILP64 && !lapack.isILP64;

stdenv.mkDerivation rec {
  pname = "tblite";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "tblite";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-KV2fxB+SF4LilN/87YCvxUt4wsY4YyIV4tqnn+3/0oI=";
  };

  nativeBuildInputs = [
    gfortran
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    blas
    lapack
    mctc-lib
    mstore
    toml-f
    multicharge
    dftd4
    simple-dftd3
  ];

  outputs = [
    "out"
    "dev"
  ];

  doCheck = true;
  preCheck = ''
    export OMP_NUM_THREADS=2
  '';

  meta = with lib; {
    description = "Light-weight tight-binding framework";
    mainProgram = "tblite";
    license = with licenses; [
      gpl3Plus
      lgpl3Plus
    ];
    homepage = "https://github.com/tblite/tblite";
    platforms = platforms.linux;
    maintainers = [ maintainers.sheepforce ];
  };
}
