{
  lib,
  buildPythonPackage,
  python,
  fetchFromGitHub,
  scikit-build-core,
  cmake,
  ninja,
  nanobind,
  pkg-config,
  numpy,
  clipper2,
  tbb,
  glm,
  pytestCheckHook,
  trimesh,
}:

let
  # archived library, but manifold3d has removed this on master
  thrust-src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "thrust";
    rev = "refs/tags/2.1.0";
    hash = "sha256-U9WgRZva7R/bNOF5VZTvIwIQDQDD3/bRO08j2TPLl9Q=";
    fetchSubmodules = true;
  };

in

buildPythonPackage rec {
  pname = "manifold3d";
  version = "2.5.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "elalish";
    repo = "manifold";
    rev = "refs/tags/v${version}";
    hash = "sha256-0zjS4ygt85isP1jyiTCeD/umhQ8ffIN+u2CeLeybX9U=";
    fetchSubmodules = true;
  };

  dontUseCmakeConfigure = true;

  build-system = [
    scikit-build-core
    cmake
    ninja
    nanobind
    pkg-config
  ];

  dependencies = [
    numpy
  ];

  buildInputs = [
    glm
    tbb
    clipper2
  ];

  env.SKBUILD_CMAKE_DEFINE = "FETCHCONTENT_SOURCE_DIR_THRUST=${thrust-src}";

  nativeCheckInputs = [
    pytestCheckHook
    trimesh
  ];

  preCheck = ''
    ${python.interpreter} bindings/python/examples/run_all.py
  '';

  pythonImportsCheck = [
    "manifold3d"
  ];

  meta = {
    description = "Geometry library for topological robustness";
    homepage = "https://github.com/elalish/manifold";
    changelog = "https://github.com/elalish/manifold/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ pbsds ];
  };
}
