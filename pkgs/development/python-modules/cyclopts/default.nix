{
  lib,
  attrs,
  buildPythonPackage,
  docstring-parser,
  fetchFromGitHub,
  hatchling,
  hatch-vcs,
  pydantic,
  pytest-mock,
  pytestCheckHook,
  pyyaml,
  rich-rst,
  rich,
  trio,
}:

buildPythonPackage rec {
  pname = "cyclopts";
  version = "4.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "BrianPugh";
    repo = "cyclopts";
    tag = "v${version}";
    hash = "sha256-dBI7ax7ljmCrE7ymcMa/B9uMtLyRTC42unrKBJ9QYQg=";
  };

  build-system = [
    hatchling
    hatch-vcs
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
  ]
  ++ lib.flatten (builtins.attrValues optional-dependencies);

  pythonImportsCheck = [ "cyclopts" ];

  disabledTests = [
    # Test requires bash
    "test_positional_not_treated_as_command"
  ];

  disabledTestPaths = [
    # Tests requires sphinx
    "tests/test_sphinx_ext.py"
  ];

  meta = with lib; {
    description = "Module to create CLIs based on Python type hints";
    homepage = "https://github.com/BrianPugh/cyclopts";
    changelog = "https://github.com/BrianPugh/cyclopts/releases/tag/${src.tag}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
