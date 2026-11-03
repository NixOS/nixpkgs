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

buildPythonPackage (finalAttrs: {
  pname = "inline-snapshot";
  version = "0.36.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "15r10nk";
    repo = "inline-snapshot";
    tag = "v${finalAttrs.version}";
    hash = "sha256-jfsWt14Znx/0z7b+FYUZwSMkpIO+oJlXGkEd3zoeT4Q=";
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
  ++ lib.concatAttrValues finalAttrs.passthru.optional-dependencies;

  optional-dependencies = {
    black = [ black ];
    dirty-equals = [ dirty-equals ];
  };

  pythonImportsCheck = [ "inline_snapshot" ];

  disabledTests = [
    # matches pytest output, which changes in 9.2
    "test_pytest_diff_fix"
  ];

  disabledTestPaths = [
    # Tests don't play nice with pytest-xdist
    "tests/test_typing.py"
    # Sensitive to formatter versions
    "tests/test_docs.py"
  ];

  meta = {
    description = "Create and update inline snapshots in Python tests";
    homepage = "https://github.com/15r10nk/inline-snapshot/";
    changelog = "https://github.com/15r10nk/inline-snapshot/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
