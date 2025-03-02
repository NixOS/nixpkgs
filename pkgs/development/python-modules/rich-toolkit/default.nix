{
  lib,
  buildPythonPackage,
  fetchPypi,

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
  version = "0.13.2";
  pyproject = true;

  # No tags on Git
  # https://github.com/patrick91/rich-toolkit/issues/21
  src = fetchPypi {
    pname = "rich_toolkit";
    inherit version;
    hash = "sha256-/qklV1MN58KPEhy+1XKtk9ng3cYMPKZD8bgx8vVrldM=";
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
    description = "Rich toolkit for building command-line applications";
    homepage = "https://pypi.org/project/rich-toolkit";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
  };
}
