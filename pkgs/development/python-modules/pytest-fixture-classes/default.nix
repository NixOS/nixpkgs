{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  typing-extensions,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "pytest-fixture-classes";
  version = "1.0.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "zmievsa";
    repo = "pytest-fixture-classes";
    tag = finalAttrs.version;
    hash = "sha256-we4Eax6wHlsbDoCzSUcbfwX+o2h3xCTaQZ3f5wStvZM=";
  };

  build-system = [
    hatchling
  ];

  dependencies = [
    typing-extensions
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "pytest_fixture_classes"
  ];

  meta = {
    description = "Fixtures as classes that work well with dependency injection, autocompletetion, type checkers, and language servers";
    homepage = "https://github.com/zmievsa/pytest-fixture-classes";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
