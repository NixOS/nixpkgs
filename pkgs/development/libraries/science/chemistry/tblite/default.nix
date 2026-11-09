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

stdenv.mkDerivation (finalAttrs: {
  pname = "tblite";
  version = "0.8.0";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "tblite";
    repo = "tblite";
    tag = "v${finalAttrs.version}";
    hash = "sha256-mB083d8mGdDznIh1kTfiJ+yEeRbYScV3UWuAOsSdygg=";
  };

  patches = [
    # Several C-API functions with bind(C) were not declared as public in their
    # Fortran modules, leading to link errors with gfortran 16.
    ./fix-c-api-visibility-gfortran16.patch

    # Fix double absolute paths in generated cmake target files
    ./cmake-paths.patch
  ];

  postPatch =
    # Python scripts in test subdirectories to run the tests
    ''
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

  mesonFlags = [
    "-Dddx=false"
    "-Dhdf5=disabled"
    "-Dtrexio=disabled"
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

  checkPhase = ''
    runHook preCheck

    # `meson test` has no per-test exclusion flag (only whole suites via
    # --suite/--no-suite), and the flaky `xtbml*` tests are spread across the
    # `unit` and `cli` suites. Build the test list dynamically and drop the
    # `xtbml*` entries by name.
    meson test --no-rebuild --print-errorlogs --max-lines=1000000 \
      --timeout-multiplier=0 \
      $(meson test --list | sed 's/^.* - //' | grep ':' | grep -v 'xtbml')

    runHook postCheck
  '';

  doCheck = buildType == "meson";

  meta = {
    description = "Light-weight tight-binding framework";
    mainProgram = "tblite";
    license = lib.licenses.lgpl3Plus;
    homepage = "https://github.com/tblite/tblite";
    changelog = "https://github.com/tblite/tblite/releases/tag/${finalAttrs.src.tag}";
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.sheepforce ];
  };
})
