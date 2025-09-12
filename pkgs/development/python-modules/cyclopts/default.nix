{
  lib,
  attrs,
  buildPythonPackage,
  docstring-parser,
  fetchFromGitHub,
  poetry-core,
  poetry-dynamic-versioning,
  pydantic,
  pytest-mock,
  pytestCheckHook,
  pythonOlder,
  pyyaml,
  rich-rst,
  rich,
  trio,
}:

buildPythonPackage rec {
  pname = "cyclopts";
  version = "3.23.1";
  pyproject = true;

  disabled = pythonOlder "3.12";

  src = fetchFromGitHub {
    owner = "BrianPugh";
    repo = "cyclopts";
    tag = "v${version}";
    hash = "sha256-qKQcx38b/GfFvJHXToLGkszBf5inRLfZTvcCX0MCaYk=";
  };

  build-system = [
    poetry-core
    poetry-dynamic-versioning
  ];

  dependencies = [
    attrs
    docstring-parser
    rich
    rich-rst
  ];

  optional-dependencies = {
    trio = [ trio ];
    yaml = [ pyyaml ];
  };

  nativeCheckInputs = [
    pydantic
    pytest-mock
    pytestCheckHook
    pyyaml
  ]
  ++ lib.flatten (builtins.attrValues optional-dependencies);

  pythonImportsCheck = [ "cyclopts" ];

  disabledTests = [
    # Assertion error
    "test_pydantic_error_msg"
  ];

  meta = with lib; {
    description = "Module to create CLIs based on Python type hints";
    homepage = "https://github.com/BrianPugh/cyclopts";
    changelog = "https://github.com/BrianPugh/cyclopts/releases/tag/${src.tag}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
