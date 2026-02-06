{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  replaceVars,
  nanobind,

  # build-system
  cmake,
  setuptools,
  typing-extensions,

  # buildInputs
  apple-sdk,
  fmt,
  nlohmann_json,
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
  version = "0.30.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ml-explore";
    repo = "mlx";
    tag = "v${finalAttrs.version}";
    hash = "sha256-OJk6jPlbaSlsUdk3ADz3tWcRzTWXRof3/q8Soe1AO6w=";
  };

  patches = [
    # Use nix packages instead of fetching their sources
    ./dont-fetch-nanobind.patch
    ./dont-fetch-json.patch
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    (replaceVars ./darwin-build-fixes.patch {
      sdkVersion = apple-sdk.version;
    })
  ];

  postPatch = ''
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
    PYPI_RELEASE = 1;
    CMAKE_ARGS = toString (
      [
        # NOTE The `metal` command-line utility used to build the Metal kernels is not open-source.
        # To build mlx with Metal support in Nix, you'd need to use one of the sandbox escape
        # hatches which let you interact with a native install of Xcode, such as `composeXcodeWrapper`
        # or by changing the upstream (e.g., https://github.com/zed-industries/zed/discussions/7016).
        (lib.cmakeBool "MLX_BUILD_METAL" false)
        (lib.cmakeBool "USE_SYSTEM_FMT" true)
        (lib.cmakeOptionType "filepath" "FETCHCONTENT_SOURCE_DIR_GGUFLIB" "${gguf-tools}")
        (lib.cmakeFeature "CMAKE_CXX_FLAGS" "-I${lib.getDev nlohmann_json}/include/nlohmann")

        # Cmake cannot find nanobind-config.cmake by itself
        (lib.cmakeFeature "nanobind_DIR" "${nanobind}/${python.sitePackages}/nanobind/cmake")
      ]
      ++ lib.optionals (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isx86_64) [
        (lib.cmakeBool "MLX_ENABLE_X64_MAC" true)
      ]
    );
  };

  build-system = [
    cmake
    setuptools
    typing-extensions
  ];

  buildInputs = [
    fmt
    nlohmann_json
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

  disabledTests = [
    # brittle memory leak test, see: https://github.com/ml-explore/mlx/pull/3088
    "test_siblings_without_eval"
  ]
  ++ lib.optionals (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isx86_64) [
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
  };
})
