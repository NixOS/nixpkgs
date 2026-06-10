{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  graphviz,
  hatchling,
  hatch-vcs,
  packaging,
  pip-requirements-parser,
  pytestCheckHook,
  pytest-mock,
  pytest-subprocess,
  rich,
  virtualenv,
}:

buildPythonPackage rec {
  pname = "pipdeptree";
  version = "3.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tox-dev";
    repo = "pipdeptree";
    tag = version;
    hash = "sha256-poUults9ev+5aryrZPxnxF/X9u0iivnlc1ceLxB7dys=";
  };

  build-system = [
    hatchling
    hatch-vcs
  ];

  dependencies = [ packaging ];

  optional-dependencies = {
    graphviz = [ graphviz ];
    index = [
      # nab-index # Unstable + not packaged yet
      # nab-python # Same
      pip-requirements-parser
    ];
    rich = [ rich ];
  };

  nativeCheckInputs = [
    pytest-mock
    pytest-subprocess
    pytestCheckHook
    virtualenv
  ]
  ++ lib.concatAttrValues optional-dependencies;

  pythonImportsCheck = [ "pipdeptree" ];

  disabledTests = [
    # Don't run console tests
    "test_console"
  ];

  meta = {
    description = "Command line utility to show dependency tree of packages";
    homepage = "https://github.com/tox-dev/pipdeptree";
    changelog = "https://github.com/tox-dev/pipdeptree/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      charlesbaynham
      mdaniels5757
    ];
    mainProgram = "pipdeptree";
  };
}
