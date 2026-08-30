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
  version = "0.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "home-assistant-libs";
    repo = "iotawattpy";
    tag = "v${finalAttrs.version}";
    hash = "sha256-yPWQisSBeAGx5bTCXq6HeJmH06Frk7zlP+9kpoOHTOo=";
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
