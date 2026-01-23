{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  logfury,
  annotated-types,
  packaging,
  pdm-backend,
  pytest-lazy-fixtures,
  pytest-mock,
  pytest-timeout,
  pytestCheckHook,
  pythonAtLeast,
  pythonOlder,
  requests,
  responses,
  tqdm,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "b2sdk";
  version = "2.10.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Backblaze";
    repo = "b2-sdk-python";
    tag = "v${version}";
    hash = "sha256-RWHD1ARPSKHmGKY0xdCBn3Qj4GxAfn4o8eacMQ5RT1k=";
  };

  build-system = [ pdm-backend ];

  dependencies = [
    annotated-types
    packaging
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
