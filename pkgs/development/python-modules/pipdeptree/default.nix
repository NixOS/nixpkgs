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
  version = "2.3.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "naiquevin";
    repo = "pipdeptree";
    rev = "refs/tags/${version}";
    hash = "sha256-X3SVQzBg+QjBSewRsfiyLqIea0duhe1nUf8ancWLvcI=";
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
    graphviz = [ graphviz ];
  };

  checkInputs = [
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
    homepage = "https://github.com/naiquevin/pipdeptree";
    license = licenses.mit;
    maintainers = with maintainers; [ charlesbaynham ];
  };
}
