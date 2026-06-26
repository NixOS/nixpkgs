{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  aiohttp,
  deepmerge,
  jmespath,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "blebox-uniapi";
  version = "2.5.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "blebox";
    repo = "blebox_uniapi";
    tag = "v${finalAttrs.version}";
    hash = "sha256-vmVCXzfs/LYn2lT3lqdRy4cJcieF1idljH5IPKeH4QA=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "pytest-runner" ""
  '';

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    jmespath
  ];

  nativeCheckInputs = [
    deepmerge
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "blebox_uniapi" ];

  meta = {
    changelog = "https://github.com/blebox/blebox_uniapi/blob/${finalAttrs.src.tag}/HISTORY.rst";
    description = "Python API for accessing BleBox smart home devices";
    homepage = "https://github.com/blebox/blebox_uniapi";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
})
