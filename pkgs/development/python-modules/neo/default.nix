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
  version = "0.14.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "NeuralEnsemble";
    repo = "python-neo";
    tag = version;
    hash = "sha256-y2MGzIfF+KrEzdjUxiDaU1ZKBK5FksX1IBJdc9RvLhM=";
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

  pythonImportsCheck = [ "neo" ];

  meta = {
    description = "Package for representing electrophysiology data";
    homepage = "https://neuralensemble.org/neo/";
    changelog = "https://neo.readthedocs.io/en/${src.tag}/releases/${src.tag}.html";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
}
