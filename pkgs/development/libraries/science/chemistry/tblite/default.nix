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

assert blas.isILP64 == lapack.isILP64;
assert (
  builtins.elem buildType [
    "meson"
    "cmake"
  ]
);

stdenv.mkDerivation (finalAttrs: {
  pname = "tblite";
  version = "0.6.0";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "tblite";
    repo = "tblite";
    tag = "v${finalAttrs.version}";
    hash = "sha256-z0g+bf6APqNLB9mDE49FelitQ9ptZXdFQuYeXIT0NIw=";
  };

  patches = [
    ./0001-fix-multicharge-dep-needed-for-static-compilation.patch

    # Fix wrong paths in pkg-config file
    ./pkgconfig.patch

    # Several C-API functions with bind(C) were not declared as public in their
    # Fortran modules, leading to link errors with gfortran 16.
    ./fix-c-api-visibility-gfortran16.patch
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

  # For the Meson build, the `custom` LAPACK vendor is used with explicit
  # library names when ILP64 is enabled, because nixpkgs always provides the
  # BLAS library as `libblas` (regardless of the integer size).
  mesonFlags = lib.optionals blas.isILP64 [
    "-Dlapack=custom"
    "-Dcustom_libraries=blas,lapack"
  ];

  # For the CMake build, tell FindLAPACK to search for the ILP64 interface.
  cmakeFlags = lib.optionals blas.isILP64 [
    "-DBLA_SIZEOF_INTEGER=8"
  ];

  outputs = [
    "out"
    "dev"
  ];

  nativeCheckInputs = [
    # Runs python test drivers (test/*/tester.py) during checkPhase, so it must be available on the
    # build host (strictDeps)
    python3
  ];

  checkFlags = [
    "-j1" # Tests hang when multiple are run in parallel
  ];

  doCheck = buildType == "meson";

  meta = {
    description = "Light-weight tight-binding framework";
    mainProgram = "tblite";
    license = with lib.licenses; [
      gpl3Plus
      lgpl3Plus
    ];
    homepage = "https://github.com/tblite/tblite";
    changelog = "https://github.com/tblite/tblite/releases/tag/${finalAttrs.src.tag}";
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.sheepforce ];
  };
})
