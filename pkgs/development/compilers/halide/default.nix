{
  stdenv,
  llvmPackages,
  lib,
  fetchFromGitHub,
  cmake,
  flatbuffers,
  libffi,
  libpng,
  libjpeg,
  libgbm,
  libGL,
  eigen,
  openblas,
  vulkan-headers,
  wabt,
  blas,
  lapack,
  pythonSupport ? false,
  python3Packages ? null,
}:

assert blas.implementation == "openblas" && lapack.implementation == "openblas";

stdenv.mkDerivation (finalAttrs: {
  pname = "halide";
  version = "19.0.0";

  src = fetchFromGitHub {
    owner = "halide";
    repo = "Halide";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0SFGX4G6UR8NS4UsdFOb99IBq2/hEkr/Cm2p6zkIh/8=";
  };

  # postPatch = ''
  #   # See https://github.com/halide/Halide/issues/7785
  #   substituteInPlace 'src/runtime/HalideRuntime.h' \
  #     --replace-fail '#if defined(__x86_64__) || defined(__i386__) || defined(__arm__) || defined(__aarch64__)
  #   #define HALIDE_CPP_COMPILER_HAS_FLOAT16' \
  #               '#if defined(__x86_64__) || defined(__i386__)
  #   #define HALIDE_CPP_COMPILER_HAS_FLOAT16'
  # '';

  cmakeFlags = [
    "-DWARNINGS_AS_ERRORS=OFF"
    "-DWITH_PYTHON_BINDINGS=${if pythonSupport then "ON" else "OFF"}"
    "-DTARGET_WEBASSEMBLY=OFF"
    # Disable performance tests since they may fail on busy machines
    "-DWITH_TEST_PERFORMANCE=OFF"
    # Disable fuzzing tests -- this has become the default upstream after the
    # v16 release (See https://github.com/halide/Halide/commit/09c5d1d19ec8e6280ccbc01a8a12decfb27226ba)
    # These tests also fail to compile on Darwin because of some missing command line options...
    "-DWITH_TEST_FUZZ=OFF"
    # Instead of fetching dependencies, use the one from nixpkgs
    "-DHalide_USE_FETCHCONTENT=OFF"
  ];

  doCheck = true;

  preCheck =
    let
      disabledTests = lib.strings.concatStringsSep "|" [
        # Requires too much parallelism for remote builders.
        "mullapudi2016_fibonacci"
        # Take too long---we don't want to run these in CI.
        "adams2019_test_apps_autoscheduler"
        "anderson2021_test_apps_autoscheduler"
        "correctness_cross_compilation"
        "correctness_simd_op_check_hvx"
      ];
    in
    ''
      checkFlagsArray+=("ARGS=-E '${disabledTests}'")
    '';

  postInstall = lib.optionalString pythonSupport ''
    mkdir -p $out/${builtins.dirOf python3Packages.python.sitePackages}
    mv -v $out/lib/python3/site-packages $out/${python3Packages.python.sitePackages}
    rmdir $out/lib/python3/
  '';

  # Note: only openblas and not atlas part of this Nix expression
  # see pkgs/development/libraries/science/math/liblapack/3.5.0.nix
  # to get a hint howto setup atlas instead of openblas
  buildInputs =
    [
      llvmPackages.llvm
      llvmPackages.lld
      llvmPackages.openmp
      llvmPackages.libclang
      libffi
      libpng
      libjpeg
      eigen
      openblas
      vulkan-headers
      wabt
    ]
    ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
      libgbm
      libGL
    ];

  nativeBuildInputs =
    [
      cmake
      flatbuffers
    ]
    ++ lib.optionals pythonSupport [
      python3Packages.python
      python3Packages.pybind11
    ];

  propagatedBuildInputs = lib.optionals pythonSupport [
    python3Packages.numpy
    python3Packages.imageio
  ];

  meta = {
    description = "C++ based language for image processing and computational photography";
    homepage = "https://halide-lang.org";
    changelog = "https://github.com/halide/Halide/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [
      ck3d
      atila
      twesterhout
    ];
  };
})
