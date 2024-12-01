{
  lib,
  buildPythonPackage,
  cryptography,
  fetchFromGitHub,
  httpx,
  pytest-aiohttp,
  pytest-mock,
  pytestCheckHook,
  pythonOlder,
  respx,
  setuptools,
}:

buildPythonPackage rec {
  pname = "ha-philipsjs";
  version = "3.3.3";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "danielperna84";
    repo = "ha-philipsjs";
    rev = "refs/tags/${version}";
    hash = "sha256-CQfT+jCICHjnldM7sjJN47dTD4WVkxfXmW5g80mnoTU=";
  };

  build-system = [ setuptools ];

  dependencies = [
    cryptography
    httpx
  ];

  nativeCheckInputs = [
    pytest-aiohttp
    pytest-mock
    pytestCheckHook
    respx
  ];

  pythonImportsCheck = [ "haphilipsjs" ];

  meta = with lib; {
    description = "Library to interact with Philips TVs with jointSPACE API";
    homepage = "https://github.com/danielperna84/ha-philipsjs";
    changelog = "https://github.com/danielperna84/ha-philipsjs/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
