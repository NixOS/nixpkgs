{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  python3Packages,
  pybind11,
  cmake,
  xcbuild,
  zsh,
  blas,
  lapack,
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
    rev = "v3.11.3";
    hash = "sha256-7F0Jon+1oWL7uqet5i1IgHX0fUw/+z0QwEcA3zs5xHg=";
  };
in
buildPythonPackage rec {
  pname = "mlx";
  version = "0.15.1";

  src = fetchFromGitHub {
    owner = "ml-explore";
    repo = "mlx";
    rev = "refs/tags/v${version}";
    hash = "sha256-+vgHEt+L91YJLpQo4bps+Rnm/TS1PAPXNohdICGK6GE=";
  };

  pyproject = true;

  patches = [
    # With Darwin SDK 11 we cannot include vecLib/cblas_new.h, this needs to wait for PR #229210
    # In the meantime, pretend Accelerate is not available and use blas/lapack instead.
    ./disable-accelerate.patch
  ];

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace "/usr/bin/xcrun" "${xcbuild}/bin/xcrun" \
  '';

  dontUseCmakeConfigure = true;

  env = {
    PYPI_RELEASE = version;
    # we can't use Metal compilation with Darwin SDK 11
    CMAKE_ARGS = toString [
      (lib.cmakeBool "MLX_BUILD_METAL" false)
      (lib.cmakeOptionType "filepath" "FETCHCONTENT_SOURCE_DIR_GGUFLIB" "${gguf-tools}")
      (lib.cmakeOptionType "filepath" "FETCHCONTENT_SOURCE_DIR_JSON" "${nlohmann_json}")
    ];
  };

  nativeBuildInputs = [
    cmake
    pybind11
    xcbuild
    zsh
    gguf-tools
    nlohmann_json
  ] ++ (with python3Packages; [ setuptools ]);

  buildInputs = [
    blas
    lapack
  ];

  meta = with lib; {
    homepage = "https://github.com/ml-explore/mlx";
    description = "Array framework for Apple silicon";
    changelog = "https://github.com/ml-explore/mlx/releases/tag/v${version}";
    license = licenses.mit;
    platforms = [ "aarch64-darwin" ];
    maintainers = with maintainers; [ viraptor ];
  };
}
