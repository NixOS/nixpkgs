{
  lib,
  attrs,
  buildPythonPackage,
  docstring-parser,
  fetchFromGitHub,
  importlib-metadata,
  poetry-core,
  poetry-dynamic-versioning,
  pydantic,
  pytest-mock,
  pytestCheckHook,
  pythonOlder,
  pyyaml,
  rich,
  rich-rst,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "cyclopts";
  version = "3.3.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "BrianPugh";
    repo = "cyclopts";
    tag = "v${version}";
    hash = "sha256-PrhaUUzFQJ7tqUdu7nwi9k+NxQUPQWYDUc9vsvnmfeY=";
  };

  build-system = [
    poetry-core
    poetry-dynamic-versioning
  ];

  dependencies = [
    attrs
    docstring-parser
    importlib-metadata
    rich
    rich-rst
    typing-extensions
  ];

  nativeCheckInputs = [
    pydantic
    pytest-mock
    pytestCheckHook
    pyyaml
  ];

  pythonImportsCheck = [ "cyclopts" ];

  disabledTests = [
    # Assertion error
    "test_pydantic_error_msg"
  ];

  meta = with lib; {
    description = "Module to create CLIs based on Python type hints";
    homepage = "https://github.com/BrianPugh/cyclopts";
    changelog = "https://github.com/BrianPugh/cyclopts/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
