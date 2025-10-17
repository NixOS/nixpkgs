{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  opentelemetry-api,
  opentelemetry-sdk,
  pytest-asyncio,
  pytest-mock,
  pytestCheckHook,
  pythonOlder,
  std-uritemplate,
  gitUpdater,
}:

buildPythonPackage rec {
  pname = "microsoft-kiota-abstractions";
  version = "1.9.7";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "kiota-python";
    tag = "microsoft-kiota-abstractions-v${version}";
    hash = "sha256-ovmGka0YxhjPQYodHAMpcrqLMpXEqSTeky3n/rC7Ohs=";
  };

  sourceRoot = "${src.name}/packages/abstractions/";

  build-system = [ poetry-core ];

  dependencies = [
    opentelemetry-api
    opentelemetry-sdk
    std-uritemplate
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-mock
    pytestCheckHook
  ];

  disabledTests = [
    # ValueError: Illegal class passed as substitution, found <class 'datetime.datetime'> at col: 39
    "test_sets_datetime_values_in_path_parameters"
  ];

  pythonImportsCheck = [ "kiota_abstractions" ];

  # detects the wrong tag on the repo
  passthru.skipBulkUpdate = true;

  passthru.updateScript = gitUpdater {
    rev-prefix = "microsoft-kiota-abstractions-v";
  };

  meta = with lib; {
    description = "Abstractions library for Kiota generated Python clients";
    homepage = "https://github.com/microsoft/kiota-python/tree/main/packages/abstractions/";
    changelog = "https://github.com/microsoft/kiota-python/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
