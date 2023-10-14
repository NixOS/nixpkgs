{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, diff-cover
, graphviz
, hatchling
, hatch-vcs
, pytest-mock
, pytestCheckHook
, pip
, virtualenv
}:

buildPythonPackage rec {
  pname = "pipdeptree";
  version = "2.13.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "tox-dev";
    repo = "pipdeptree";
    rev = "refs/tags/${version}";
    hash = "sha256-mblj6SQK/az2al81wMiWXHuyn1+30jfAxrWGv9Nw/gw=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    hatchling
    hatch-vcs
  ];

  propagatedBuildInputs = [
    pip
  ];

  passthru.optional-dependencies = {
    graphviz = [
      graphviz
    ];
  };

  nativeCheckInputs = [
    diff-cover
    pytest-mock
    pytestCheckHook
    virtualenv
  ] ++ lib.flatten (builtins.attrValues passthru.optional-dependencies);

  pythonImportsCheck = [
    "pipdeptree"
  ];

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
  };
}
