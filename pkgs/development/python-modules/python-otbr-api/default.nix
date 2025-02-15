{
  lib,
  aiohttp,
  bitstruct,
  buildPythonPackage,
  cryptography,
  fetchFromGitHub,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  typing-extensions,
  voluptuous,
}:

buildPythonPackage rec {
  pname = "python-otbr-api";
  version = "2.7.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "home-assistant-libs";
    repo = "python-otbr-api";
    tag = version;
    hash = "sha256-irQ4QvpGIAYYKq0UqLuo7Nrnde905+GJFd4HkxsCDmQ=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    bitstruct
    cryptography
    typing-extensions
    voluptuous
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "python_otbr_api" ];

  meta = with lib; {
    description = "Library for the Open Thread Border Router";
    homepage = "https://github.com/home-assistant-libs/python-otbr-api";
    changelog = "https://github.com/home-assistant-libs/python-otbr-api/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
