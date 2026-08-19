{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
  hypothesis,
}:
buildPythonPackage rec {
  pname = "condense-json";
  version = "1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "simonw";
    repo = "condense-json";
    tag = version;
    hash = "sha256-IBYjDFhbQlZ/17nTo5FvJM7aeadKS5dW7J8IGy4956M=";
  };

  build-system = [
    setuptools
  ];

  nativeCheckInputs = [
    pytestCheckHook
    hypothesis
  ];

  pythonImportsCheck = [ "condense_json" ];

  meta = {
    description = "Python function for condensing JSON using replacement strings";
    homepage = "https://github.com/simonw/condense-json";
    changelog = "https://github.com/simonw/condense-json/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      josh
      dwt
    ];
  };
}
