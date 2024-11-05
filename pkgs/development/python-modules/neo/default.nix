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
  version = "0.13.3";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "NeuralEnsemble";
    repo = "python-neo";
    rev = "refs/tags/${version}";
    hash = "sha256-7Q80vbQInVWxPCr6VvmI9tFfTIAzo9FPJ19q51Xd2KM=";
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
    changelog = "https://neo.readthedocs.io/en/${version}/releases/${version}.html";
    license = licenses.bsd3;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
