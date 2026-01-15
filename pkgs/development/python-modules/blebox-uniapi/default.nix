{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  aiohttp,
  semver,
  deepmerge,
  jmespath,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "blebox-uniapi";
  version = "2.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "blebox";
    repo = "blebox_uniapi";
    tag = "v${version}";
    hash = "sha256-johTs1AGvC6mGasK87ijhBNbHb1m36Ep9TR8XPG35d0=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "pytest-runner" ""
  '';

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    aiohttp
    jmespath
    semver
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
