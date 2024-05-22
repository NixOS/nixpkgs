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
  version = "3.2.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "danielperna84";
    repo = "ha-philipsjs";
    rev = "refs/tags/${version}";
    hash = "sha256-gN7TPbNGw1vT0oAE6+Kg4V3J5dhYH+Gvv3JwptQ2aMk=";
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
