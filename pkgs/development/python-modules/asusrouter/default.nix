{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  aiohttp,
  pytest-asyncio,
  pytestCheckHook,
  urllib3,
  xmltodict,
}:

buildPythonPackage rec {
  pname = "asusrouter";
  version = "1.18.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Vaskivskyi";
    repo = "asusrouter";
    tag = version;
    hash = "sha256-8kETQKvPwURyEabK/g8Ub+aLcPPTRs0FFWbSNU4jJZc=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools==80.9.0" "setuptools"
  '';

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    urllib3
    xmltodict
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "asusrouter" ];

  meta = {
    description = "API wrapper for communication with ASUSWRT-powered routers using HTTP protocol";
    homepage = "https://github.com/Vaskivskyi/asusrouter";
    changelog = "https://github.com/Vaskivskyi/asusrouter/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ];
  };
}
