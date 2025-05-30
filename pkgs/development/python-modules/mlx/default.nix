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
  nanobind,
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
  nlohmann_json = fetchFromGitHub {
    owner = "nlohmann";
    repo = "json";
    rev = "v3.11.3";
    hash = "sha256-7F0Jon+1oWL7uqet5i1IgHX0fUw/+z0QwEcA3zs5xHg=";
  };
  fmt = fetchFromGitHub {
    owner = "fmtlib";
    repo = "fmt";
    rev = "10.2.1";
    hash = "sha256-pEltGLAHLZ3xypD/Ur4dWPWJ9BGVXwqQyKcDWVmC3co=";
  };
in
let
  mlx = buildPythonPackage rec {
    pname = "mlx";
    version = "0.25.2";
    pyproject = true;

    src = fetchFromGitHub {
      owner = "ml-explore";
      repo = "mlx";
      rev = "refs/tags/v${version}";
      hash = "sha256-fkf/kKATr384WduFG/X81c5InEAZq5u5+hwrAJIg7MI=";
    };

    patches = [
      (replaceVars ./darwin-build-fixes.patch {
        sdkVersion = apple-sdk_14.version;
      })
    ];

    postPatch = ''
      substituteInPlace pyproject.toml \
        --replace-fail "nanobind==2.4.0" "nanobind>=2.4.0" \

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
        (lib.cmakeOptionType "filepath" "FETCHCONTENT_SOURCE_DIR_JSON" "${nlohmann_json}")
        (lib.cmakeOptionType "filepath" "FETCHCONTENT_SOURCE_DIR_FMT" "${fmt}")
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

    meta = with lib; {
      homepage = "https://github.com/ml-explore/mlx";
      description = "Array framework for Apple silicon";
      changelog = "https://github.com/ml-explore/mlx/releases/tag/v${version}";
      license = licenses.mit;
      platforms = [ "aarch64-darwin" ];
      maintainers = with maintainers; [
        viraptor
        Gabriella439
        cameronyule
      ];
    };
  };
in
mlx
