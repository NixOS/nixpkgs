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
  version = "0.15.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "patrick91";
    repo = "rich-toolkit";
    tag = version;
    hash = "sha256-NcdABfbqE+VzE6bptBO98Cf7jetlfVqa/LB5Chg/P8Y=";
  };

  build-system = [ hatchling ];

  dependencies = [
    click
    rich
    typing-extensions
  ];

  nativeCheckInputs = [
    inline-snapshot
    pytestCheckHook
  ];

  pythonImportsCheck = [ "rich_toolkit" ];

  meta = {
    changelog = "https://github.com/patrick91/rich-toolkit/releases/tag/${src.tag}";
    description = "Rich toolkit for building command-line applications";
    homepage = "https://github.com/patrick91/rich-toolkit/";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
