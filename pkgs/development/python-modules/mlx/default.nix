{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  replaceVars,
  stdenv,

  # build-system
  setuptools,

  # nativeBuildInputs
  cmake,

  # buildInputs
  apple-sdk_14,
  fmt_10,
  nanobind,
  nlohmann_json,
  pybind11,

  # tests
  numpy,
  pytestCheckHook,
  python,
  runCommand,
}:

let
  # static dependencies included directly during compilation
  gguf-tools = fetchFromGitHub {
    owner = "antirez";
    repo = "gguf-tools";
    rev = "8fa6eb65236618e28fd7710a0fba565f7faa1848";
    hash = "sha256-15FvyPOFqTOr5vdWQoPnZz+mYH919++EtghjozDlnSA=";
  };

  mlx = buildPythonPackage rec {
    pname = "mlx";
    version = "0.26.3";
    pyproject = true;

    src = fetchFromGitHub {
      owner = "ml-explore";
      repo = "mlx";
      tag = "v${version}";
      hash = "sha256-hbqV/2KYGJ1gyExZd5bgaxTdhl5+Gext+U/+1KAztMU=";
    };

    patches = [
      (replaceVars ./darwin-build-fixes.patch {
        sdkVersion = apple-sdk_14.version;
      })
    ];

    postPatch = ''
      substituteInPlace pyproject.toml \
        --replace-fail "nanobind==2.4.0" "nanobind>=2.4.0"

      substituteInPlace mlx/backend/cpu/jit_compiler.cpp \
        --replace-fail "g++" "$CXX"
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
      PYPI_RELEASE = version;
      CMAKE_ARGS = toString [
        # NOTE The `metal` command-line utility used to build the Metal kernels is not open-source.
        # To build mlx with Metal support in Nix, you'd need to use one of the sandbox escape
        # hatches which let you interact with a native install of Xcode, such as `composeXcodeWrapper`
        # or by changing the upstream (e.g., https://github.com/zed-industries/zed/discussions/7016).
        (lib.cmakeBool "MLX_BUILD_METAL" false)
        (lib.cmakeOptionType "filepath" "FETCHCONTENT_SOURCE_DIR_GGUFLIB" "${gguf-tools}")
        (lib.cmakeOptionType "filepath" "FETCHCONTENT_SOURCE_DIR_JSON" "${nlohmann_json.src}")
        (lib.cmakeOptionType "filepath" "FETCHCONTENT_SOURCE_DIR_FMT" "${fmt_10.src}")
      ];
    };

    build-system = [
      setuptools
    ];

    nativeBuildInputs = [
      cmake
    ];

    buildInputs = [
      apple-sdk_14
      fmt_10
      gguf-tools
      nanobind
      nlohmann_json
      pybind11
    ];

    pythonImportsCheck = [ "mlx" ];

    # Run the mlx Python test suite.
    nativeCheckInputs = [
      numpy
      pytestCheckHook
    ];

    pytestFlagsArray = [
      "python/tests/"
    ];

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
            cp ${src}/examples/python/logistic_regression.py .
            ${python.interpreter} logistic_regression.py
            rm logistic_regression.py

            cp ${src}/examples/python/linear_regression.py .
            ${python.interpreter} linear_regression.py
            rm linear_regression.py

            touch $out
          '';
    };

    meta = {
      homepage = "https://github.com/ml-explore/mlx";
      description = "Array framework for Apple silicon";
      changelog = "https://github.com/ml-explore/mlx/releases/tag/${src.tag}";
      license = lib.licenses.mit;
      platforms = [ "aarch64-darwin" ];
      maintainers = with lib.maintainers; [
        viraptor
        Gabriella439
        cameronyule
      ];
    };
  };
in
mlx
