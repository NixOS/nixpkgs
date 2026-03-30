{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  stdenv,
}:

buildPythonPackage rec {
  pname = "aspy-refactor-imports";
  version = "4.2.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "asottile";
    repo = "aspy.refactor_imports";
    tag = "v${version}";
    sha256 = "sha256-f5wZfisKz9WGdq6u0rd/zg2CfMwWvQeR8xZQNbD7KfU=";
  };

  pythonImportsCheck = [ "aspy.refactor_imports" ];

  nativeCheckInputs = [ pytestCheckHook ];

  # fails on darwin due to case-insensitive file system
  disabledTests = lib.optionals stdenv.hostPlatform.isDarwin [ "test_application_directory_case" ];

  meta = {
    description = "Utilities for refactoring imports in python-like syntax";
    homepage = "https://github.com/asottile/aspy.refactor_imports";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ gador ];
  };
}
