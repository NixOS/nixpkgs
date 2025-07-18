{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  numpy,
  pdm-backend,
  pytestCheckHook,
  pythonAtLeast,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "jsonconversion";
  version = "1.1.1";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "DLR-RM";
    repo = "python-jsonconversion";
    tag = version;
    hash = "sha256-FGgvSDweZM1xrdrDLFiGmdAtgxoFjglUlMV+fgo7/ls=";
  };

  build-system = [ pdm-backend ];

  pythonRemoveDeps = [
    "pytest-runner"
    "pytest"
  ];

  pythonRelaxDeps = [ "numpy" ];

  dependencies = [
    numpy
    setuptools
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "jsonconversion" ];

  disabledTests = lib.optionals (pythonAtLeast "3.13") [ "test_dict" ];

  meta = with lib; {
    description = "This python module helps converting arbitrary Python objects into JSON strings and back";
    homepage = "https://github.com/DLR-RM/python-jsonconversion";
    changelog = "https://github.com/DLR-RM/python-jsonconversion/releases/tag/${version}";
    license = licenses.bsd2;
    maintainers = with maintainers; [ terlar ];
  };
}
