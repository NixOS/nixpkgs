{
  lib,
  stdenv,
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
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "tblite";
    repo = "tblite";
    rev = "v${version}";
    hash = "sha256-z0g+bf6APqNLB9mDE49FelitQ9ptZXdFQuYeXIT0NIw=";
  };

  patches = [
    ./0001-fix-multicharge-dep-needed-for-static-compilation.patch

    # Fix wrong paths in pkg-config file
    ./pkgconfig.patch
  ];

  postPatch =
    # Python scripts in test subdirectories to run the tests
    ''
      patchShebangs ./
    ''

    # libquadmath is only shipped by GCC on architectures that lack native
    # quad-precision support (e.g. x86_64); on aarch64 it does not exist.
    + lib.optionalString (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64) ''
      substituteInPlace config/meson.build \
        --replace-fail "lib_deps += cc.find_library('quadmath')" ""
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

  meta = {
    description = "Light-weight tight-binding framework";
    mainProgram = "tblite";
    license = with lib.licenses; [
      gpl3Plus
      lgpl3Plus
    ];
    homepage = "https://github.com/tblite/tblite";
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.sheepforce ];
  };
}
