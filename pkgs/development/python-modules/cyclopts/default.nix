{
  lib,
  attrs,
  buildPythonPackage,
  docstring-parser,
  fetchFromGitHub,
  hatch-vcs,
  hatchling,
  markdown,
  mkdocs,
  pydantic,
  pymdown-extensions,
  pytest-mock,
  pytestCheckHook,
  pyyaml,
  rich-rst,
  rich,
  sphinx,
  syrupy,
  trio,
}:

buildPythonPackage rec {
  pname = "cyclopts";
  version = "4.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "BrianPugh";
    repo = "cyclopts";
    tag = "v${version}";
    hash = "sha256-cU3emBHwwXFoymriN9kCYQ4lRJwaiUIwOene7mUkexM=";
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
    docs = [ sphinx ];
    mkdocs = [
      mkdocs
      markdown
      pymdown-extensions
    ];
  };

  nativeCheckInputs = [
    pydantic
    pytest-mock
    pytestCheckHook
    syrupy
  ]
  ++ lib.concatAttrValues optional-dependencies;

  pythonImportsCheck = [ "cyclopts" ];

  disabledTests = [
    # Test requires bash
    "test_positional_not_treated_as_command"
    # Building docs
    "build_succeeds"
  ];

  disabledTestPaths = [
    # Tests requires sphinx
    "tests/test_sphinx_ext.py"
  ];

  meta = {
    description = "Module to create CLIs based on Python type hints";
    homepage = "https://github.com/BrianPugh/cyclopts";
    changelog = "https://github.com/BrianPugh/cyclopts/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}
