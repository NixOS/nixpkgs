{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  pythonOlder,
  pytestCheckHook,
  # deps
  email-validator,
  hatchling,
  jinja2,
  lxml,
  multidict,
  ollama,
  pydantic,
  pyyaml,
  # dev deps
  pytest-factoryboy,
  pytest-mock,
}:

buildPythonPackage rec {
  pname = "beanhub-inbox";
  version = "0.2.3";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "LaunchPlatform";
    repo = "beanhub-inbox";
    tag = version;
    hash = "sha256-WWfZsJRm2rJI85vmFt/AtV++5vpSTJZpRrk3PdHMhAA=";
  };

  build-system = [ hatchling ];

  dependencies = [
    email-validator
    jinja2
    lxml
    ollama
    pydantic
    pyyaml
  ];

  nativeCheckInputs = [
    pytest-factoryboy
    pytest-mock
    pytestCheckHook
  ];

  pythonImportsCheck = [ "beanhub_inbox" ];

  meta = {
    description = "Library for email processing, archiving and extracting financial data with LLM";
    homepage = "https://github.com/LaunchPlatform/beanhub-inbox/";
    changelog = "https://github.com/LaunchPlatform/beanhub-inbox/releases/tag/${version}";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fangpen ];
  };
}
