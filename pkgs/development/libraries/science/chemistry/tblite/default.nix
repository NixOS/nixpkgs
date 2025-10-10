{
  stdenv,
  lib,
  fetchFromGitHub,
  gfortran,
  buildType ? "meson",
  meson,
  ninja,
  cmake,
  pkg-config,
  blas,
  lapack,
  mctc-lib,
  mstore,
  toml-f,
  multicharge,
  dftd4,
  simple-dftd3,
  python3,
}:

assert !blas.isILP64 && !lapack.isILP64;
assert (
  builtins.elem buildType [
    "meson"
    "cmake"
  ]
);

stdenv.mkDerivation rec {
  pname = "tblite";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "tblite";
    repo = "tblite";
    rev = "v${version}";
    hash = "sha256-hePy/slEeM2o1gtrAbq/nkEUILa6oQjkD2ddDstQ2Zc=";
  };

  patches = [
    ./0001-fix-multicharge-dep-needed-for-static-compilation.patch

    # Fix wrong paths in pkg-config file
    ./pkgconfig.patch
  ];

  # Python scripts in test subdirectories to run the tests
  postPatch = ''
    patchShebangs ./
  '';

  nativeBuildInputs = [
    gfortran
    pkg-config
  ]
  ++ lib.optionals (buildType == "meson") [
    meson
    ninja
  ]
  ++ lib.optionals (buildType == "cmake") [
    cmake
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

  checkInputs = [
    python3
  ];

  checkFlags = [
    "-j1" # Tests hang when multiple are run in parallel
  ];

  doCheck = buildType == "meson";

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
