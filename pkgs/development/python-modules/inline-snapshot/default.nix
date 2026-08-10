{
  lib,
  asttokens,
  black,
  buildPythonPackage,
  dirty-equals,
  executing,
  fetchFromGitHub,
  hatchling,
  hypothesis,
  isort,
  pydantic,
  pytest,
  pytest-freezer,
  pytest-mock,
  pytest-xdist,
  pytestCheckHook,
  rich,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "inline-snapshot";
  version = "0.34.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "15r10nk";
    repo = "inline-snapshot";
    tag = version;
    hash = "sha256-4Uvc925/6RxJRHjP3SZaB7T+gqky5KlL9agHy/14Jd0=";
  };

  build-system = [ hatchling ];

  buildInputs = [
    pytest
  ];

  dependencies = [
    asttokens
    executing
    rich
    typing-extensions
  ];

  nativeCheckInputs = [
    hypothesis
    isort
    pydantic
    pytest-freezer
    pytest-mock
    pytest-xdist
    pytestCheckHook
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
