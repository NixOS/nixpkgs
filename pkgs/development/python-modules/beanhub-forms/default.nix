{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  pythonOlder,
  pytestCheckHook,
  jinja2,
  multidict,
  poetry-core,
  pydantic,
  pyyaml,
  wtforms,
}:

buildPythonPackage rec {
  pname = "beanhub-forms";
  version = "0.1.3";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "LaunchPlatform";
    repo = "beanhub-forms";
    rev = "refs/tags/${version}";
    hash = "sha256-313c+ENmTe1LyfEiMXNB9AUoGx3Yv/1D0T3HnAbd+Zw=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    jinja2
    pydantic
    pyyaml
    wtforms
  ];

  nativeCheckInputs = [
    multidict
    pytestCheckHook
  ];

  pythonImportsCheck = [ "beanhub_forms" ];

  meta = {
    description = "Library for generating and processing BeanHub's custom forms";
    homepage = "https://github.com/LaunchPlatform/beanhub-forms/";
    changelog = "https://github.com/LaunchPlatform/beanhub-forms/releases/tag/${version}";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fangpen ];
  };
}
