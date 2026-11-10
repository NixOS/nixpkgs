{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  numpy,
  packaging,
  quantities,
  setuptools,
  pytestCheckHook,
  pillow,
  which,
}:

buildPythonPackage rec {
  pname = "neo";
  version = "0.14.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "NeuralEnsemble";
    repo = "python-neo";
    tag = version;
    hash = "sha256-IB+RuQBJTu0Ss7PLdBpONBl50xdTiR512ni+w3Z+DEM=";
  };

  build-system = [ setuptools ];

  dependencies = [
    numpy
    packaging
    quantities
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pillow
    which
  ];

  disabledTestPaths = [
    # Requires network and export HOME dir
    "neo/test/rawiotest/test_maxwellrawio.py"
  ];

  disabledTests = [
    # numpy 2.x boolean index strictness regression
    "test__time_slice_deepcopy_data"
  ];

  pythonImportsCheck = [ "neo" ];

  meta = {
    description = "Package for representing electrophysiology data";
    homepage = "https://neuralensemble.org/neo/";
    changelog = "https://neo.readthedocs.io/en/${src.tag}/releases/${src.tag}.html";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
}
