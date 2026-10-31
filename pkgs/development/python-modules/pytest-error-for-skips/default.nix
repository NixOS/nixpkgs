{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytest,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pytest-error-for-skips";
  version = "2.0.2";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "jankatins";
    repo = "pytest-error-for-skips";
    rev = version;
    hash = "sha256-GY9L8sgmcWKWUbFZseUSK9E63m9AAeiksI+St0aTJBI=";
  };

  buildInputs = [ pytest ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pytest_error_for_skips" ];

  meta = {
    description = "Pytest plugin to treat skipped tests a test failures";
    homepage = "https://github.com/jankatins/pytest-error-for-skips";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
