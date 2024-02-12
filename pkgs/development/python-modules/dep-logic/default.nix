{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, pdm-backend
, packaging
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "dep-logic";
  version = "0.0.4";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "pdm-project";
    repo = "dep-logic";
    rev = version;
    hash = "sha256-AFiCNzHlo3BADqbjRBruA80cfM6Ytdb+gReEg5hUmro=";
  };

  nativeBuildInputs = [
    pdm-backend
  ];

  propagatedBuildInputs = [
    packaging
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "dep_logic"
  ];

  meta = {
    changelog = "https://github.com/pdm-project/dep-logic/releases/tag/${src.rev}";
    description = "Python dependency specifications supporting logical operations";
    homepage = "https://github.com/pdm-project/dep-logic";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ tomasajt ];
  };
}
