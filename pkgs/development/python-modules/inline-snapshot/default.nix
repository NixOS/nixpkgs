{
  lib,
  asttokens,
  black,
  buildPythonPackage,
  dirty-equals,
  executing,
  fetchFromGitHub,
  freezegun,
  hatchling,
  hypothesis,
  pydantic,
  pyright,
  pytest-freezer,
  pytest-mock,
  pytest-xdist,
  pytestCheckHook,
  pythonOlder,
  rich,
  time-machine,
  toml,
}:

buildPythonPackage rec {
  pname = "inline-snapshot";
  version = "0.31.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "15r10nk";
    repo = "inline-snapshot";
    tag = version;
    hash = "sha256-45e3M7WjGLhmn1Tdf7fD04jSA32TvB0QmFzvywJc3Ac=";
  };

  build-system = [ hatchling ];

  dependencies = [
    asttokens
    executing
    rich
    toml
  ]
  ++ lib.optionals (pythonOlder "3.11") [
    toml
  ];

  nativeCheckInputs = [
    freezegun
    hypothesis
    pydantic
    pyright
    pytest-freezer
    pytest-mock
    pytest-xdist
    pytestCheckHook
    time-machine
  ]
  ++ lib.concatAttrValues optional-dependencies;

  optional-dependencies = {
    black = [ black ];
    dirty-equals = [ dirty-equals ];
  };

  pythonImportsCheck = [ "inline_snapshot" ];

  disabledTestPaths = [
    # Tests don't play nice with pytest-xdist
    "tests/test_typing.py"
  ];

  meta = {
    description = "Create and update inline snapshots in Python tests";
    homepage = "https://github.com/15r10nk/inline-snapshot/";
    changelog = "https://github.com/15r10nk/inline-snapshot/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
