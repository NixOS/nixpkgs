{
  lib,
  attrs,
  buildPythonPackage,
  docstring-parser,
  fetchFromGitHub,
<<<<<<< HEAD
  hatch-vcs,
  hatchling,
  markdown,
  mkdocs,
  pydantic,
  pymdown-extensions,
=======
  hatchling,
  hatch-vcs,
  pydantic,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pytest-mock,
  pytestCheckHook,
  pyyaml,
  rich-rst,
  rich,
<<<<<<< HEAD
  sphinx,
  syrupy,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  trio,
}:

buildPythonPackage rec {
  pname = "cyclopts";
<<<<<<< HEAD
  version = "4.4.1";
=======
  version = "4.2.5";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "BrianPugh";
    repo = "cyclopts";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-kp/mnqa2difEA3s1jtXF1fDluQhLCJ4f6rFRruRbE9k=";
=======
    hash = "sha256-5OGQLAHDh3wkGxiYPXt6Txc4naSmuyDWojZA9ZgZwMo=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD
    docs = [ sphinx ];
    mkdocs = [
      mkdocs
      markdown
      pymdown-extensions
    ];
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  nativeCheckInputs = [
    pydantic
    pytest-mock
    pytestCheckHook
<<<<<<< HEAD
    syrupy
  ]
  ++ lib.concatAttrValues optional-dependencies;
=======
  ]
  ++ lib.flatten (builtins.attrValues optional-dependencies);
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  pythonImportsCheck = [ "cyclopts" ];

  disabledTests = [
    # Test requires bash
    "test_positional_not_treated_as_command"
<<<<<<< HEAD
    # Building docs
    "build_succeeds"
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  ];

  disabledTestPaths = [
    # Tests requires sphinx
    "tests/test_sphinx_ext.py"
  ];

<<<<<<< HEAD
  meta = {
    description = "Module to create CLIs based on Python type hints";
    homepage = "https://github.com/BrianPugh/cyclopts";
    changelog = "https://github.com/BrianPugh/cyclopts/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
=======
  meta = with lib; {
    description = "Module to create CLIs based on Python type hints";
    homepage = "https://github.com/BrianPugh/cyclopts";
    changelog = "https://github.com/BrianPugh/cyclopts/releases/tag/${src.tag}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
