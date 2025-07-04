{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  numpy,
  packaging,
  quantities,
  pythonOlder,
  setuptools,
  pytestCheckHook,
  pillow,
  which,
}:

buildPythonPackage rec {
  pname = "neo";
  version = "0.14.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "NeuralEnsemble";
    repo = "python-neo";
    tag = version;
    hash = "sha256-n0+K1J6K3WYN+1LxcHoVuA+U3LeiRG0EsicJf5uKvnE=";
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

  meta = with lib; {
    description = "Package for representing electrophysiology data";
    homepage = "https://neuralensemble.org/neo/";
    changelog = "https://neo.readthedocs.io/en/${src.tag}/releases/${src.tag}.html";
    license = licenses.bsd3;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
