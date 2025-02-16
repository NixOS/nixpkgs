{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  django,
  pytestCheckHook,
  pythonOlder,
  pytest-django,
}:

buildPythonPackage rec {
  pname = "model-bakery";
  version = "1.20.3";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "model-bakers";
    repo = "model_bakery";
    tag = version;
    hash = "sha256-0zLlX0AfGDnSrV3gqheYBUwX7+iJQjBER8EEtXwVkbA=";
  };

  build-system = [ hatchling ];

  dependencies = [ django ];

  nativeCheckInputs = [
    pytest-django
    pytestCheckHook
  ];

  pythonImportsCheck = [ "model_bakery" ];

  meta = with lib; {
    description = "Object factory for Django";
    homepage = "https://github.com/model-bakers/model_bakery";
    changelog = "https://github.com/model-bakers/model_bakery/blob/${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
