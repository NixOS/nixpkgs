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
  pytestCheckHook,
  trimesh,
}:

buildPythonPackage rec {
  pname = "manifold3d";
  version = "3.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "elalish";
    repo = "manifold";
    tag = "v${version}";
    hash = "sha256-wbeWxAeKyqjEPemc2e5n357gwq83pQlASOvMd0ZCE7g=";
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
    tbb
    clipper2
  ];

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
    maintainers = with lib.maintainers; [
      pbsds
      pca006132
    ];
  };
}
