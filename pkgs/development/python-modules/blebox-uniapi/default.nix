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

buildPythonPackage rec {
  pname = "blebox-uniapi";
  version = "2.5.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "blebox";
    repo = "blebox_uniapi";
    tag = "v${version}";
    hash = "sha256-DBkd8o2jOVCH3KqJ2FZ4qhJsSMb1UwqBO1ZXoTLsqEY=";
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
    changelog = "https://github.com/blebox/blebox_uniapi/blob/v${version}/HISTORY.rst";
    description = "Python API for accessing BleBox smart home devices";
    homepage = "https://github.com/blebox/blebox_uniapi";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
