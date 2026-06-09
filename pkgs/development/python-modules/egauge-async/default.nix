{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  uv-dynamic-versioning,
  httpx,
  pytest-asyncio,
  pytest-mock,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "egauge-async";
  version = "0.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "neggert";
    repo = "egauge-async";
    tag = "v${finalAttrs.version}";
    hash = "sha256-MbOjyHxCZpJDZIRyWShk2+X1Di8zX4JjyEpLUnHfdzE=";
  };

  build-system = [
    hatchling
    uv-dynamic-versioning
  ];

  dependencies = [
    httpx
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-mock
    pytestCheckHook
  ];

  disabledTestMarks = [
    "integration"
  ];

  pythonImportsCheck = [
    "egauge_async"
  ];

  meta = {
    description = "Async client for eGauge energy monitor";
    homepage = "https://github.com/neggert/egauge-async";
    changelog = "https://github.com/neggert/egauge-async/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ jamiemagee ];
  };
})
