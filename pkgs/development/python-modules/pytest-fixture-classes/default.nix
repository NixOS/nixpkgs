{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  poetry-core,
  pytest,
  pytestCheckHook,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "pytest-fixture-classes";
  version = "1.0.3";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "zmievsa";
    repo = "pytest-fixture-classes";
    tag = version;
    hash = "sha256-A3HsDhCGxoJnkl841tZ/7lIn8UyGy5NRjVWODZV7aOQ=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    typing-extensions
  ];

  pythonImportsCheck = [ "pytest_fixture_classes" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Fixtures as classes that work well with dependency injection, autocompletetion, type checkers, and language servers";
    homepage = "https://github.com/zmievsa/pytest-fixture-classes";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ taranarmo ];
  };
}
