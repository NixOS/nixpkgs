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
  version = "1.18.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "model-bakers";
    repo = "model_bakery";
    rev = "refs/tags/${version}";
    hash = "sha256-mf6NV7r/9kDCRlszx/QGtfEsC1O/SATd6+EX+w7ptEQ=";
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
