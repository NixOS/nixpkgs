{
  lib,
  buildPythonPackage,
  fetchFromGitLab,
  hatchling,
  numpy,
  pandas,
  polars,
  pytest,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pytest-regtest";
  version = "2.3.2";
  pyproject = true;

  src = fetchFromGitLab {
    owner = "uweschmitt";
    repo = "pytest-regtest";
    rev = version;
    hash = "sha256-admWKQCds858Z6rL0iJTB8tWVEev7NfkLTgIis6KZi4=";
  };

  build-system = [
    hatchling
  ];

  dependencies = [
    pytest
  ];

  nativeBuildInputs = [
    pytestCheckHook
  ];

  checkInputs = [
    numpy
    pandas
    polars
  ];

  pythonImportsCheck = [
    "pytest_regtest"
  ];

  meta = {
    description = "pytest plugin to implement regression testing";
    homepage = "https://gitlab.com/uweschmitt/pytest-regtest";
    changelog = "https://gitlab.com/uweschmitt/pytest-regtest/-/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nim65s ];
  };
}
