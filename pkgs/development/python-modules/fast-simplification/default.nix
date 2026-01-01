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
<<<<<<< HEAD
  version = "0.1.13";
=======
  version = "0.1.12";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pyvista";
    repo = "fast-simplification";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-MgAOGB4wJQ68GyotaxiR9Xdho+TckHKEglQvCE2TWVY=";
=======
    hash = "sha256-OhVJKYmJR+A6JDaM/7Bfkc4PNlhsc6NgRNU+SokCg1U=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
