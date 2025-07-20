{
  lib,
  buildPythonPackage,
  python,
  fetchFromGitHub,
  scikit-build-core,
  manifold,
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
  inherit (manifold) version src;
  pyproject = true;

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
    inherit (manifold.meta)
      homepage
      changelog
      description
      license
      ;
    maintainers = with lib.maintainers; [
      pbsds
      pca006132
    ];
  };
}
