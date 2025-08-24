{
  buildPythonPackage,
  email-validator,
  fetchFromGitHub,
  hatchling,
  jinja2,
  lib,
  lxml,
  ollama,
  pydantic,
  pytest-factoryboy,
  pytest-mock,
  pytestCheckHook,
  pythonOlder,
  pyyaml,
}:

buildPythonPackage rec {
  pname = "beanhub-inbox";
  version = "0.2.3";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "LaunchPlatform";
    repo = "beanhub-inbox";
    tag = version;
    hash = "sha256-WWfZsJRm2rJI85vmFt/AtV++5vpSTJZpRrk3PdHMhAA=";
  };

  build-system = [ hatchling ];

  dependencies = [
    jinja2
    pydantic
    pyyaml
    ollama
    lxml
    email-validator
  ];

  nativeCheckInputs = [
    pytest-factoryboy
    pytest-mock
    pytestCheckHook
  ];

  pythonImportsCheck = [ "beanhub_inbox" ];

  meta = {
    description = "Email processing engine for archiving and extracting financial data with LLM";
    homepage = "https://github.com/LaunchPlatform/beanhub-inbox/";
    changelog = "https://github.com/LaunchPlatform/beanhub-inbox/releases/tag/${version}";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ polyfloyd ];
  };
}
