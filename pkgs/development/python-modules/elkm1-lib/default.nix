{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pyserial-asyncio-fast,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "elkm1-lib";
  version = "2.2.15";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "gwww";
    repo = "elkm1";
    tag = finalAttrs.version;
    hash = "sha256-LDzc/njgPGjc9uhNMHG4NOn9P2Sy3lFHgwV9oJJLl2o=";
  };

  build-system = [ hatchling ];

  dependencies = [ pyserial-asyncio-fast ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "elkm1_lib" ];

  meta = {
    description = "Module for interacting with ElkM1 alarm/automation panel";
    homepage = "https://github.com/gwww/elkm1";
    changelog = "https://github.com/gwww/elkm1/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
