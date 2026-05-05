{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  logfury,
  annotated-types,
  hatchling,
  hatch-vcs,
  pytest-lazy-fixtures,
  pytest-mock,
  pytest-timeout,
  pytestCheckHook,
  pythonAtLeast,
  pythonOlder,
  requests,
  responses,
  tenacity,
  tqdm,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "b2sdk";
  version = "2.11.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Backblaze";
    repo = "b2-sdk-python";
    tag = "v${version}";
    hash = "sha256-gnJHTrOau0zZdYP4mDY+uuni41VfnRxC1uP17b+r9yU=";
  };

  build-system = [
    hatchling
    hatch-vcs
  ];

  dependencies = [
    annotated-types
    logfury
    requests
  ]
  ++ lib.optionals (pythonOlder "3.12") [ typing-extensions ];

  nativeCheckInputs = [
    pytest-lazy-fixtures
    pytest-mock
    pytest-timeout
    pytestCheckHook
    responses
    tenacity
    tqdm
  ];

  enabledTestPaths = [
    "test/unit"
  ];

  disabledTests = lib.optionals (pythonAtLeast "3.14") [
    # -     'could not be accessed (no permissions to read?)',
    # +     'could not be accessed (broken symlink?)',
    "test_dir_without_exec_permission"
  ];

  pythonImportsCheck = [ "b2sdk" ];

  meta = {
    description = "Client library and utilities for access to B2 Cloud Storage (backblaze)";
    homepage = "https://github.com/Backblaze/b2-sdk-python";
    changelog = "https://github.com/Backblaze/b2-sdk-python/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pmw ];
  };
}
