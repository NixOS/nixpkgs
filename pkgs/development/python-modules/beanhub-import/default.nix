{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  pytestCheckHook,
  beancount-black,
  beancount-parser,
  beanhub-extract,
  hatchling,
  jinja2,
  pydantic,
  pytz,
  pyyaml,
}:

buildPythonPackage rec {
  pname = "beanhub-import";
  version = "1.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "LaunchPlatform";
    repo = "beanhub-import";
    tag = version;
    hash = "sha256-zKlw8KEVc0FJrxWHOx95UXGzqxFFCaYBKID4hRbTQas=";
  };

  build-system = [ hatchling ];

  pythonRelaxDeps = [
    # pytz>=2023.1,<2025, but we have 2025.1
    "pytz"
  ];

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
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fangpen ];
  };
}
