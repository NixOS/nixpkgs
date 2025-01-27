{
  lib,
  asttokens,
  black,
  buildPythonPackage,
  click,
  dirty-equals,
  executing,
  fetchFromGitHub,
  freezegun,
  hatchling,
  hypothesis,
  pydantic,
  pyright,
  pytest-freezer,
  pytest-subtests,
  pytest-xdist,
  pytestCheckHook,
  pythonOlder,
  rich,
  time-machine,
  toml,
  types-toml,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "inline-snapshot";
  version = "0.19.3";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "15r10nk";
    repo = "inline-snapshot";
    tag = version;
    hash = "sha256-bgzDjlcZOxS3OCv8xj7qKllaZcfJaxySXOu7OwY2EIQ=";
  };

  build-system = [ hatchling ];

  dependencies =
    [
      asttokens
      black
      click
      executing
      rich
      typing-extensions
    ]
    ++ lib.optionals (pythonOlder "3.11") [
      types-toml
      toml
    ];

  nativeCheckInputs = [
    dirty-equals
    freezegun
    hypothesis
    pydantic
    pyright
    pytest-freezer
    pytest-subtests
    pytest-xdist
    pytestCheckHook
    time-machine
  ];

  pythonImportsCheck = [ "inline_snapshot" ];

  disabledTestPaths = [
    # Tests don't play nice with pytest-xdist
    "tests/test_typing.py"
    "tests/test_formating.py"
  ];

  meta = with lib; {
    description = "Create and update inline snapshots in Python tests";
    homepage = "https://github.com/15r10nk/inline-snapshot/";
    changelog = "https://github.com/15r10nk/inline-snapshot/blob/${src.tag}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
