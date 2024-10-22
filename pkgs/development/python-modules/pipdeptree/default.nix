{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  diff-cover,
  graphviz,
  hatchling,
  hatch-vcs,
  packaging,
  pytest-mock,
  pytestCheckHook,
  pip,
  virtualenv,
}:

buildPythonPackage rec {
  pname = "pipdeptree";
  version = "2.23.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "tox-dev";
    repo = "pipdeptree";
    rev = "refs/tags/${version}";
    hash = "sha256-yEiehHcJcVC0hjb9NFgsrSxmAsxNki8HNGKk8dEk75s=";
  };

  build-system = [
    hatchling
    hatch-vcs
  ];

  dependencies = [
    pip
    packaging
  ];

  optional-dependencies = {
    graphviz = [ graphviz ];
  };

  nativeCheckInputs = [
    diff-cover
    pytest-mock
    pytestCheckHook
    virtualenv
  ] ++ lib.flatten (builtins.attrValues optional-dependencies);

  pythonImportsCheck = [ "pipdeptree" ];

  disabledTests = [
    # Don't run console tests
    "test_console"
  ];

  meta = with lib; {
    description = "Command line utility to show dependency tree of packages";
    homepage = "https://github.com/tox-dev/pipdeptree";
    changelog = "https://github.com/tox-dev/pipdeptree/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ charlesbaynham ];
    mainProgram = "pipdeptree";
  };
}
