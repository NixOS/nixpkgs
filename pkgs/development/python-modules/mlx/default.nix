{
  lib,
  fetchFromGitHub,
  buildPythonPackage,

  # build-system
  cmake,
  nanobind,
  pybind11,
  setuptools,

  # nativeBuildInputs
  xcbuild,
  zsh,

  # buildInputs
  blas,
  lapack,
  fmt,

  # tests
  pytestCheckHook,
}:

let
  # static dependencies included directly during compilation
  gguf-tools = fetchFromGitHub {
    owner = "antirez";
    repo = "gguf-tools";
    rev = "af7d88d808a7608a33723fba067036202910acb3";
    hash = "sha256-LqNvnUbmq0iziD9VP5OTJCSIy+y/hp5lKCUV7RtKTvM=";
  };
  nlohmann_json = fetchFromGitHub {
    owner = "nlohmann";
    repo = "json";
    tag = "v3.11.3";
    hash = "sha256-7F0Jon+1oWL7uqet5i1IgHX0fUw/+z0QwEcA3zs5xHg=";
  };
in
buildPythonPackage rec {
  pname = "mlx";
  version = "0.26.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ml-explore";
    repo = "mlx";
    tag = "v${version}";
    hash = "sha256-Tql8jbth3uSGicxreUCdUynb+VM1wARU6BjGkaQdrd8=";
  };

  patches = [
    # Use nixpkgs' fmt library instead of fetching it from GitHub
    ./dont-fetch-fmt.patch
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "nanobind==2.4.0" "nanobind"

    substituteInPlace CMakeLists.txt \
      --replace-fail "/usr/bin/xcrun" "${lib.getExe' xcbuild "xcrun"}" \
  '';

  # updates the wrong fetcher rev attribute
  passthru.skipBulkUpdate = true;

  env = {
    PYPI_RELEASE = version;
    # we can't use Metal compilation with Darwin SDK 11
    CMAKE_ARGS = toString [
      (lib.cmakeBool "MLX_BUILD_METAL" false)
      (lib.cmakeOptionType "filepath" "FETCHCONTENT_SOURCE_DIR_GGUFLIB" "${gguf-tools}")
      (lib.cmakeOptionType "filepath" "FETCHCONTENT_SOURCE_DIR_JSON" "${nlohmann_json}")
    ];
  };

  build-system = [
    cmake
    nanobind
    pybind11
    setuptools
  ];
  dontUseCmakeConfigure = true;

  nativeBuildInputs = [
    xcbuild
    zsh
    gguf-tools
    nlohmann_json
  ];

  buildInputs = [
    blas
    lapack
    fmt
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = {
    homepage = "https://github.com/ml-explore/mlx";
    description = "Array framework for Apple silicon";
    changelog = "https://github.com/ml-explore/mlx/releases/tag/v${version}";
    license = lib.licenses.mit;
    platforms = [ "aarch64-darwin" ];
    maintainers = with lib.maintainers; [
      viraptor
      Gabriella439
    ];
  };
}
