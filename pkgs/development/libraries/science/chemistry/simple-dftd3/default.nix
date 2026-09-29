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
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "dftd3";
    repo = "simple-dftd3";
    tag = "v${version}";
    hash = "sha256-THl8sUY7pLxFz4mY7FMj/c1hwzqLaaNNMq0qkxWkUzw=";
  };

  # set_model_ghost_index was not declared as part of the public api, leading
  # to link errors with gfortran 16.
  postPatch = ''
    substituteInPlace src/dftd3/api.f90 --replace-fail \
      "public :: set_model_ewald, set_model_work_partition" \
      "public :: set_model_ewald, set_model_ghost_index, set_model_work_partition"
  '';

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
