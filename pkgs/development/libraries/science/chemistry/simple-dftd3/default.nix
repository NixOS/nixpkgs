{
  stdenv,
  lib,
  fetchFromGitHub,
  gfortran,
  meson,
  ninja,
  cmake,
  pkg-config,
  mctc-lib,
  mstore,
  toml-f,
  blas,
  buildType ? "meson",
}:

assert !blas.isILP64;
assert (
  builtins.elem buildType [
    "meson"
    "cmake"
  ]
);

stdenv.mkDerivation rec {
  pname = "simple-dftd3";
  version = "1.3.2";

  src = fetchFromGitHub {
    owner = "dftd3";
    repo = "simple-dftd3";
    tag = "v${version}";
    hash = "sha256-h9KFqZOfH7c7hntfL/C5WG9HVof64O4U1BNCCOuQhpA=";
  };

  patches = [
    ./cmake.patch
  ];

  nativeBuildInputs = [
    gfortran
    pkg-config
  ]
  ++ lib.optionals (buildType == "meson") [
    meson
    ninja
  ]
  ++ lib.optional (buildType == "cmake") cmake;

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

  cmakeFlags = [
    (lib.strings.cmakeBool "BUILD_SHARED_LIBS" (!stdenv.hostPlatform.isStatic))
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
