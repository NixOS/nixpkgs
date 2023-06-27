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
  version = "2.9.3";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "tox-dev";
    repo = "pipdeptree";
    rev = "refs/tags/${version}";
    hash = "sha256-CNz/TxIxaRzBzlylLgWWW7xom65tK7ZnGtwpMsTDqVk=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    hatchling
    hatch-vcs
  ];

  propagatedBuildInput = [
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

  meta = with lib; {
    description = "Command line utility to show dependency tree of packages";
    homepage = "https://github.com/tox-dev/pipdeptree";
    changelog = "https://github.com/tox-dev/pipdeptree/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ charlesbaynham ];
  };
}
