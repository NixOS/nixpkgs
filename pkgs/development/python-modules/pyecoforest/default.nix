{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  httpx,
  poetry-core,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
  respx,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyecoforest";
  version = "0.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pjanuario";
    repo = "pyecoforest";
    tag = "v${finalAttrs.version}";
    hash = "sha256-C8sFq0vsVsq6irWbRd0eq18tfKu0qRRBZHt23CiDTGU=";
  };

  build-system = [ poetry-core ];

  dependencies = [ httpx ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-cov-stub
    pytestCheckHook
    respx
  ];

  disabledTests = [
    # respx.models.AllMockedAssertionError
    "test_get"
    "test_get_errors"
    "test_set_temperature"
    "test_set_power"
    "test_turn"
  ];

  pythonImportsCheck = [ "pyecoforest" ];

  meta = {
    description = "Module for interacting with Ecoforest devices";
    homepage = "https://github.com/pjanuario/pyecoforest";
    changelog = "https://github.com/pjanuario/pyecoforest/blob/${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
