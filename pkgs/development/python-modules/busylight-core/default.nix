{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hidapi,
  loguru,
  pyserial,
  pytest-asyncio,
  pytestCheckHook,
  uv-build,
}:

buildPythonPackage (finalAttrs: {
  pname = "busylight-core";
  version = "2.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "JnyJny";
    repo = "busylight";
    tag = "busylight-core/v${finalAttrs.version}";
    hash = "sha256-m7ZxZkaWnkQV/KZ/xm3+uSfftL1V5Lxolx2lB63Mzyk=";
    rootDir = "packages/busylight-core";
  };

  build-system = [ uv-build ];

  dependencies = [
    hidapi
    loguru
    pyserial
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "busylight_core" ];

  meta = {
    description = "Library for interacting programmatically with USB-connected LED lights";
    homepage = "https://github.com/JnyJny/busylight";
    changelog = "https://github.com/JnyJny/busylight/blob/${finalAttrs.src.tag}/${finalAttrs.src.rootDir}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
