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
  version = "3.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "elalish";
    repo = "manifold";
    tag = "v${version}";
    hash = "sha256-dCCTjWRjXSyuEDxGI9ZS2UTmLdZVSmDOmHFnhox3N+4=";
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
    changelog = "https://github.com/elalish/manifold/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      pbsds
      pca006132
    ];
  };
}
