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
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "dftd3";
    repo = "simple-dftd3";
    tag = "v${version}";
    hash = "sha256-c4xctcMcPQ70ippqbwtinygmnZ5en6ZGF5/v0ZWtzys=";
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

<<<<<<< HEAD
  meta = {
    description = "Reimplementation of the DFT-D3 program";
    mainProgram = "s-dftd3";
    license = with lib.licenses; [
=======
  meta = with lib; {
    description = "Reimplementation of the DFT-D3 program";
    mainProgram = "s-dftd3";
    license = with licenses; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      lgpl3Only
      gpl3Only
    ];
    homepage = "https://github.com/dftd3/simple-dftd3";
<<<<<<< HEAD
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.sheepforce ];
=======
    platforms = platforms.linux;
    maintainers = [ maintainers.sheepforce ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
