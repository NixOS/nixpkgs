{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  stdenv,

  # sources
  fmt_10,
  nlohmann_json,

  # build-system
  cmake,
  nanobind,
  setuptools,

  # nativeBuildInputs
  xcbuild,
  zsh,

  # buildInputs
  apple-sdk_14,
  blas,
  lapack,

  # tests
  numpy,
  pytestCheckHook,
  python,
  runCommand,
  torch,
}:

let
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

    postPatch = ''
      substituteInPlace CMakeLists.txt \
        --replace-fail "/usr/bin/xcrun" "xcrun"

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

    env.PYPI_RELEASE = "1";

    env.CMAKE_ARGS =
      let
        gguf-tools-src = fetchFromGitHub {
          owner = "antirez";
          repo = "gguf-tools";
          rev = "8fa6eb65236618e28fd7710a0fba565f7faa1848";
          hash = "sha256-15FvyPOFqTOr5vdWQoPnZz+mYH919++EtghjozDlnSA=";
        };
      in
      toString (
        [
          # NOTE The `metal` command-line utility used to build the Metal kernels is not open-source.
          # To build mlx with Metal support in Nix, you'd need to use one of the sandbox escape
          # hatches which let you interact with a native install of Xcode, such as `composeXcodeWrapper`
          # or by changing the upstream (e.g., https://github.com/zed-industries/zed/discussions/7016).
          (lib.cmakeBool "MLX_BUILD_METAL" false)
          (lib.cmakeOptionType "filepath" "FETCHCONTENT_SOURCE_DIR_GGUFLIB" "${gguf-tools-src}")
          (lib.cmakeOptionType "filepath" "FETCHCONTENT_SOURCE_DIR_JSON" "${nlohmann_json.src}")
          (lib.cmakeOptionType "filepath" "FETCHCONTENT_SOURCE_DIR_FMT" "${fmt_10.src}")
        ]
        ++ lib.optionals stdenv.hostPlatform.isLinux [
          # RPATH of binary contains a forbidden reference to /build/
          (lib.cmakeBool "CMAKE_SKIP_BUILD_RPATH" true)
          # the default is lib64, which is not in the RPATH of the core binary
          (lib.cmakeFeature "CMAKE_INSTALL_LIBDIR" "lib")
        ]
      );

    build-system = [
      cmake
      nanobind
      setuptools
    ];

    nativeBuildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
      xcbuild
      zsh
    ];

    buildInputs =
      lib.optionals stdenv.hostPlatform.isDarwin [
        apple-sdk_14
      ]
      ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
        blas
        lapack
      ];

    # Run the mlx Python test suite.
    nativeCheckInputs = [
      numpy
      pytestCheckHook
      torch
    ];

    enabledTestPaths = [
      "python/tests/"
    ];

    pythonImportsCheck = [ "mlx" ];

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
      platforms = [ "aarch64-darwin" ] ++ lib.platforms.linux;
      maintainers = with lib.maintainers; [
        viraptor
        Gabriella439
        cameronyule
      ];
    };
  };
in
mlx
