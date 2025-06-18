{
  lib,
  aiohttp,
  aresponses,
  async-timeout,
  backoff,
  buildPythonPackage,
  fetchFromGitHub,
  mashumaro,
  orjson,
  packaging,
  poetry-core,
  pytest-asyncio,
  pytest-cov-stub,
  pytest-mock,
  pytestCheckHook,
  pythonOlder,
  yarl,
}:

buildPythonPackage rec {
  pname = "python-bsblan";
  version = "2.1.0";
  pyproject = true;

  disabled = pythonOlder "3.12";

  src = fetchFromGitHub {
    owner = "liudger";
    repo = "python-bsblan";
    tag = "v${version}";
    hash = "sha256-HaB1ypC2IkSEnM5Ek583CFvwWt1nm1gWUdoh5MH09YQ=";
  };

  postPatch = ''
    sed -i "/ruff/d" pyproject.toml
  '';

  env.PACKAGE_VERSION = version;

  build-system = [ poetry-core ];

  pythonRelaxDeps = [ "async-timeout" ];

  dependencies = [
    aiohttp
    async-timeout
    backoff
    mashumaro
    orjson
    packaging
    yarl
  ];

  nativeCheckInputs = [
    aresponses
    pytest-asyncio
    pytest-cov-stub
    pytest-mock
    pytestCheckHook
  ];

  pythonImportsCheck = [ "bsblan" ];

  meta = with lib; {
    description = "Module to control and monitor an BSBLan device programmatically";
    homepage = "https://github.com/liudger/python-bsblan";
    changelog = "https://github.com/liudger/python-bsblan/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
