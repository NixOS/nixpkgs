{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  poetry-core,

  # dependencies
  jsonschema,
  pydantic,
  sentencepiece,
  tiktoken,
  typing-extensions,

  # tests
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "mistral-common";
  version = "1.3.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mistralai";
    repo = "mistral-common";
    rev = "refs/tags/v${version}";
    hash = "sha256-53XI9boxtM1d6YBZfJbgt7kMb+GCC4b+7/SP+OqwIAQ=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    jsonschema
    pydantic
    sentencepiece
    tiktoken
    typing-extensions
  ];

  pythonImportsCheck = [ "mistral_common" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "A set of tools to help you work with Mistral models";
    homepage = "https://github.com/mistralai/mistral-common";
    changelog = "https://github.com/mistralai/mistral-common/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
