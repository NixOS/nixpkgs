{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  pythonOlder,
  pytestCheckHook,
  beancount-black,
  beancount-parser,
  beanhub-extract,
  jinja2,
  poetry-core,
  pydantic,
  pytz,
  pyyaml,
}:

buildPythonPackage rec {
  pname = "beanhub-import";
  version = "1.0.7";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "LaunchPlatform";
    repo = "beanhub-import";
    tag = version;
    hash = "sha256-lafSOk+MS9MqB9KSxVR7S1HJJ6R6RZeCrFK8JGCZAIg=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    beancount-black
    beancount-parser
    beanhub-extract
    jinja2
    pydantic
    pytz
    pyyaml
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "beanhub_import" ];

  meta = {
    description = "Declarative idempotent rule-based Beancount transaction import engine in Python";
    homepage = "https://github.com/LaunchPlatform/beanhub-import/";
    changelog = "https://github.com/LaunchPlatform/beanhub-import/releases/tag/${src.tag}";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fangpen ];
  };
}
