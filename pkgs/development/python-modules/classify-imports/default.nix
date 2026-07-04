{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "classify-imports";
  version = "4.2.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "asottile";
    repo = "classify-imports";
    tag = "v${finalAttrs.version}";
    hash = "sha256-f5wZfisKz9WGdq6u0rd/zg2CfMwWvQeR8xZQNbD7KfU=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "classify_imports" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Utilities for refactoring imports in python-like syntax";
    homepage = "https://github.com/asottile/classify-imports";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ gador ];
  };
})
