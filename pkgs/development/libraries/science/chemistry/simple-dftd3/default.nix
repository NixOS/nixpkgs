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
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "dftd3";
    repo = "simple-dftd3";
    tag = "v${version}";
    hash = "sha256-Bv+N9/dQVpSglt/54ay6mt4kRhu4klMTp7+sRP1bP80=";
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
