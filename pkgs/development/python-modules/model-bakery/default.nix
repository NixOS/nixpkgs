{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  django,
  pytestCheckHook,
  pytest-django,
}:

buildPythonPackage rec {
  pname = "model-bakery";
  version = "1.21.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "model-bakers";
    repo = "model_bakery";
    tag = version;
    hash = "sha256-BB/CaVDkqL51WvFC+GRWV3z3jHUQrW1KtIuHUn4acHw=";
  };

  build-system = [ hatchling ];

  dependencies = [ django ];

  nativeCheckInputs = [
    pytest-django
    pytestCheckHook
  ];

  pythonImportsCheck = [ "model_bakery" ];

  meta = {
    description = "Object factory for Django";
    homepage = "https://github.com/model-bakers/model_bakery";
    changelog = "https://github.com/model-bakers/model_bakery/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}
