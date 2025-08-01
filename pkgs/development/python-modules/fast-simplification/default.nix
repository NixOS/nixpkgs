{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  cython,
  numpy,
  setuptools,
  wheel,
  pytestCheckHook,
  pyvista,
  nix-update-script,
}:

buildPythonPackage rec {
  pname = "fast-simplification";
  version = "0.1.11";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pyvista";
    repo = "fast-simplification";
    tag = "v${version}";
    hash = "sha256-3mqcFTNrq1W376ctJJumzeQccaB4cvoTNW8BHEnv5t8=";
  };

  build-system = [
    cython
    numpy
    setuptools
    wheel
  ];

  dependencies = [
    numpy
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pyvista
  ];

  disabledTests = [
    # need network to download data
    "test_collapses_louis"
    "test_human"
  ];

  # make sure import the built version, not the source one
  preCheck = ''
    rm -r fast_simplification
  '';

  pythonImportsCheck = [
    "fast_simplification"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Fast Quadratic Mesh Simplification";
    homepage = "https://github.com/pyvista/fast-simplification";
    changelog = "https://github.com/pyvista/fast-simplification/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      yzx9
    ];
  };
}
