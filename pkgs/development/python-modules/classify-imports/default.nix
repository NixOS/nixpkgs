{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "classify-imports";
  version = "4.2.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "asottile";
    repo = "classify-imports";
    rev = "v${version}";
    hash = "sha256-f5wZfisKz9WGdq6u0rd/zg2CfMwWvQeR8xZQNbD7KfU=";
  };

  pythonImportsCheck = [ "classify_imports" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Utilities for refactoring imports in python-like syntax";
    homepage = "https://github.com/asottile/classify-imports";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ gador ];
  };
}
