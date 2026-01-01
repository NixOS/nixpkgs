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
  version = "0.28.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "15r10nk";
    repo = "inline-snapshot";
    tag = version;
    hash = "sha256-f572H7jeolv9nONuRBtZR/pcVDs5oX/dOiEjXlJyiio=";
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
<<<<<<< HEAD
  ++ lib.concatAttrValues optional-dependencies;
=======
  ++ lib.flatten (lib.attrValues optional-dependencies);
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  optional-dependencies = {
    black = [ black ];
    dirty-equals = [ dirty-equals ];
  };

  pythonImportsCheck = [ "inline_snapshot" ];

  disabledTestPaths = [
    # Tests don't play nice with pytest-xdist
    "tests/test_typing.py"
  ];

<<<<<<< HEAD
  meta = {
    description = "Create and update inline snapshots in Python tests";
    homepage = "https://github.com/15r10nk/inline-snapshot/";
    changelog = "https://github.com/15r10nk/inline-snapshot/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
=======
  meta = with lib; {
    description = "Create and update inline snapshots in Python tests";
    homepage = "https://github.com/15r10nk/inline-snapshot/";
    changelog = "https://github.com/15r10nk/inline-snapshot/blob/${src.tag}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
