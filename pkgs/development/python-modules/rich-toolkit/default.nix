{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatchling,

  # dependencies
  click,
  rich,
  typing-extensions,

  # tests
  inline-snapshot,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "rich-toolkit";
  version = "0.14.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "patrick91";
    repo = "rich-toolkit";
    tag = "v${version}";
    hash = "sha256-SHQZ0idEx/zDEtP0xQoJg7eUT8+SqLdWljxfTgXzjkk=";
  };

  build-system = [
    hatchling
  ];

  dependencies = [
    click
    rich
    typing-extensions
  ];

  nativeCheckInputs = [
    inline-snapshot
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "rich_toolkit"
  ];

  meta = {
    changelog = "https://github.com/patrick91/rich-toolkit/releases/tag/${src.tag}";
    description = "Rich toolkit for building command-line applications";
    homepage = "https://pypi.org/project/rich-toolkit";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
  };
}
