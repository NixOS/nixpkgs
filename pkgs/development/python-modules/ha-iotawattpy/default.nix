{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  httpx,
  hatchling,
  pytestCheckHook,
  pytest-asyncio,
  pytest-cov-stub,
  respx,
}:

buildPythonPackage (finalAttrs: {
  pname = "ha-iotawattpy";
  version = "0.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "home-assistant-libs";
    repo = "iotawattpy";
    tag = "v${finalAttrs.version}";
    hash = "sha256-7fXnl1ao/UANhV0P2iz8BE9qK7OUXBsdotnlxSNr/7I=";
  };

  build-system = [ hatchling ];

  dependencies = [ httpx ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
    pytest-cov-stub
    respx
  ];

  pythonImportsCheck = [ "iotawattpy" ];

  meta = {
    description = "Python library for the IoTaWatt Energy device";
    homepage = "https://github.com/gtdiehl/iotawattpy";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ fab ];
  };
})
