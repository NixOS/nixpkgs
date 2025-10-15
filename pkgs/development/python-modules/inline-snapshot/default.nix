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
  pytest-subtests,
  pytest-xdist,
  pytestCheckHook,
  pythonOlder,
  rich,
  time-machine,
  toml,
}:

buildPythonPackage rec {
  pname = "inline-snapshot";
  version = "0.30.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "15r10nk";
    repo = "inline-snapshot";
    tag = version;
    hash = "sha256-8XMViapMBAUmNMOZ/2XSApfmAnSOx5uRJhMFTyj8uNo=";
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
    pytest-subtests
    pytest-xdist
    pytestCheckHook
    time-machine
  ]
  ++ lib.flatten (lib.attrValues optional-dependencies);

  optional-dependencies = {
    black = [ black ];
    dirty-equals = [ dirty-equals ];
  };

  pythonImportsCheck = [ "inline_snapshot" ];

  disabledTestPaths = [
    # Tests don't play nice with pytest-xdist
    "tests/test_typing.py"
  ];

  meta = with lib; {
    description = "Create and update inline snapshots in Python tests";
    homepage = "https://github.com/15r10nk/inline-snapshot/";
    changelog = "https://github.com/15r10nk/inline-snapshot/blob/${src.tag}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
