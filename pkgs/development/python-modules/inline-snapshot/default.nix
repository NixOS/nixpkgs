{
  lib,
  asttokens,
  black,
  buildPythonPackage,
  click,
  dirty-equals,
  executing,
  fetchFromGitHub,
  hypothesis,
  poetry-core,
  pyright,
  pytest-subtests,
  pytest-xdist,
  pytestCheckHook,
  pythonOlder,
  rich,
  time-machine,
  toml,
  types-toml,
}:

buildPythonPackage rec {
  pname = "inline-snapshot";
  version = "0.10.2";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "15r10nk";
    repo = "inline-snapshot";
    rev = "refs/tags/v${version}";
    hash = "sha256-19rvhqYkM3QiD0La5TRi/2uKza8HW/bnXeGAhOZ/bgs=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    asttokens
    black
    click
    executing
    rich
    toml
    types-toml
  ];

  nativeCheckInputs = [
    dirty-equals
    hypothesis
    pyright
    pytest-subtests
    pytest-xdist
    pytestCheckHook
    time-machine
  ];

  pythonImportsCheck = [ "inline_snapshot" ];

  disabledTestPaths = [
    # Tests don't play nice with pytest-xdist
    "tests/test_typing.py"
  ];

  meta = with lib; {
    description = "Create and update inline snapshots in Python tests";
    homepage = "https://github.com/15r10nk/inline-snapshot/";
    changelog = "https://github.com/15r10nk/inline-snapshot/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
