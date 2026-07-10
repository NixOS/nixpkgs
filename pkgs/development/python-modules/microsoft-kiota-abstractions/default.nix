{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  gitUpdater,
  opentelemetry-api,
  opentelemetry-sdk,
  pytest-asyncio,
  pytest-mock,
  pytestCheckHook,
  std-uritemplate,
}:

buildPythonPackage (finalAttrs: {
  pname = "microsoft-kiota-abstractions";
  version = "1.11.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "kiota-python";
    tag = "microsoft-kiota-abstractions-v${finalAttrs.version}";
    hash = "sha256-Fd9XSO3H1Au8y+Acft5to7hi7QNwWcmP0/NeWZlufjg=";
  };

  sourceRoot = "${finalAttrs.src.name}/packages/abstractions/";

  build-system = [ flit-core ];

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

  meta = {
    description = "Abstractions library for Kiota generated Python clients";
    homepage = "https://github.com/microsoft/kiota-python/tree/main/packages/abstractions/";
    changelog = "https://github.com/microsoft/kiota-python/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
