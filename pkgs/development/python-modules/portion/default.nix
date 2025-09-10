{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  sortedcontainers,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "portion";
  version = "2.6.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "AlexandreDecan";
    repo = "portion";
    tag = version;
    hash = "sha256-K4mZn8Fm96ZBBdLTMfM9f1GKDdIrRwDRzk6ObaXSFG4=";
  };

  build-system = [ hatchling ];

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
