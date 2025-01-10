{
  lib,
  buildPythonPackage,
  fetchPypi,
  fetchFromGitHub,
  hatchling,
  pytestCheckHook,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "beartype";
  version = "0.19.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "beartype";
    repo = "beartype";
    tag = "v${version}";
    hash = "sha256-uUwqgK7K8x61J7A6S/DGLJljSKABxsbOCsFBDtsameU=";
  };

  build-system = [ hatchling ];

  nativeCheckInputs = [
    pytestCheckHook
    typing-extensions
  ];

  pythonImportsCheck = [ "beartype" ];

  meta = {
    description = "Fast runtime type checking for Python";
    homepage = "https://github.com/beartype/beartype";
    changelog = "https://github.com/beartype/beartype/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
}
