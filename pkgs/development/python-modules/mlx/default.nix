{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  replaceVars,

  # build-system
  setuptools,

  # nativeBuildInputs
  cmake,

  # buildInputs
  apple-sdk,
  fmt,
  nanobind,
  nlohmann_json,
  pybind11,
  # linux-only
  openblas,

  # tests
  numpy,
  pytestCheckHook,
  python,
  runCommand,

  # passthru
  mlx,
}:

let
  # static dependencies included directly during compilation
  gguf-tools = fetchFromGitHub {
    owner = "antirez";
    repo = "gguf-tools";
    rev = "8fa6eb65236618e28fd7710a0fba565f7faa1848";
    hash = "sha256-15FvyPOFqTOr5vdWQoPnZz+mYH919++EtghjozDlnSA=";
  };

in
buildPythonPackage (finalAttrs: {
  pname = "mlx";
  version = "0.30.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ml-explore";
    repo = "mlx";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Vt0RH+70VBwUjXSfPTsNdRS3g0ookJHhzf2kvgEtgH8=";
  };

  patches = lib.optionals stdenv.hostPlatform.isDarwin [
    (replaceVars ./darwin-build-fixes.patch {
      sdkVersion = apple-sdk.version;
    })
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "nanobind==2.10.2" "nanobind"

    substituteInPlace mlx/backend/cpu/jit_compiler.cpp \
      --replace-fail "g++" "${lib.getExe' stdenv.cc "c++"}"
  '';

  dontUseCmakeConfigure = true;

  enableParallelBuilding = true;

  # Allows multiple cores to be used in Python builds.
  postUnpack = ''
    export MAKEFLAGS+="''${enableParallelBuilding:+-j$NIX_BUILD_CORES}"
  '';

  # updates the wrong fetcher rev attribute
  passthru.skipBulkUpdate = true;

  env = {
    DEV_RELEASE = 1;
    CMAKE_ARGS = toString [
      # NOTE The `metal` command-line utility used to build the Metal kernels is not open-source.
      # To build mlx with Metal support in Nix, you'd need to use one of the sandbox escape
      # hatches which let you interact with a native install of Xcode, such as `composeXcodeWrapper`
      # or by changing the upstream (e.g., https://github.com/zed-industries/zed/discussions/7016).
      (lib.cmakeBool "MLX_BUILD_METAL" false)
      (lib.cmakeBool "USE_SYSTEM_FMT" true)
      (lib.cmakeOptionType "filepath" "FETCHCONTENT_SOURCE_DIR_GGUFLIB" "${gguf-tools}")
      (lib.cmakeOptionType "filepath" "FETCHCONTENT_SOURCE_DIR_JSON" "${nlohmann_json.src}")
    ];
  };

  build-system = [
    setuptools
  ];

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    fmt
    gguf-tools
    nanobind
    nlohmann_json
    pybind11
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    openblas
  ];

  pythonImportsCheck = [ "mlx" ];

  # Run the mlx Python test suite.
  nativeCheckInputs = [
    numpy
    pytestCheckHook
  ];

  enabledTestPaths = [
    "python/tests/"
  ];

  disabledTests = lib.optionals (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isx86_64) [
    # Segmentation fault
    "test_lapack"
    "test_multivariate_normal"
    "test_orthogonal"
    "test_vmap_inverse"
    "test_vmap_svd"
  ];

  disabledTestPaths = lib.optionals (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isx86_64) [
    # Segmentation fault
    "python/tests/test_linalg.py"
  ];

  # patchelf is only available on Linux and no patching is needed on darwin.
  # Otherwise mlx/core.cpython-313-x86_64-linux-gnu.so contains a reference to
  # /build/source/build/temp.linux-x86_64-cpython-313/mlx.core/libmlx.so in its rpath.
  postInstall = lib.optionalString stdenv.hostPlatform.isLinux ''
    patchelf --replace-needed \
      libmlx.so \
      $out/${python.sitePackages}/mlx/lib64/libmlx.so \
      $out/${python.sitePackages}/mlx/core.cpython-*.so
  '';

  # Additional testing by executing the example Python scripts supplied with mlx
  # using the version of the library we've built.
  passthru.tests = {
    mlxTest =
      runCommand "run-mlx-examples"
        {
          buildInputs = [ mlx ];
          nativeBuildInputs = [ python ];
        }
        ''
          cp ${finalAttrs.src}/examples/python/logistic_regression.py .
          ${python.interpreter} logistic_regression.py
          rm logistic_regression.py

          cp ${finalAttrs.src}/examples/python/linear_regression.py .
          ${python.interpreter} linear_regression.py
          rm linear_regression.py

          touch $out
        '';
  };

  meta = {
    homepage = "https://github.com/ml-explore/mlx";
    description = "Array framework for Apple silicon";
    changelog = "https://github.com/ml-explore/mlx/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      Gabriella439
      booxter
      cameronyule
      viraptor
    ];
    badPlatforms = [
      # Building for x86_64 on macOS is not supported
      "x86_64-darwin"
    ];
  };
})
