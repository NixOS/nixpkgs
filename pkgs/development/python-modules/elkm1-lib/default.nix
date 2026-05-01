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
  version = "2.2.14";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "gwww";
    repo = "elkm1";
    tag = finalAttrs.version;
    hash = "sha256-lejeRHteVMO7qz8qMPCG5d8V/rj550FL+WuogM/Lcbw=";
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
