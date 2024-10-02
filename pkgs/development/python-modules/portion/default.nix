{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  sortedcontainers,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "portion";
  version = "2.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "AlexandreDecan";
    repo = "portion";
    rev = "refs/tags/${version}";
    hash = "sha256-sNOieFenrWh6iDXCyCBedx+qIsS+daAr+WVBpkc8yVQ=";
  };

  build-system = [ setuptools ];

  dependencies = [ sortedcontainers ];

  pythonImportsCheck = [ "portion" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Portion, a Python library providing data structure and operations for intervals";
    homepage = "https://github.com/AlexandreDecan/portion";
    changelog = "https://github.com/AlexandreDecan/portion/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.lgpl3;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
