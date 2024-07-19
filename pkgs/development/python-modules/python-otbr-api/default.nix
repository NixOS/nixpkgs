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
  voluptuous,
}:

buildPythonPackage rec {
  pname = "python-otbr-api";
  version = "2.6.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "home-assistant-libs";
    repo = "python-otbr-api";
    rev = "refs/tags/${version}";
    hash = "sha256-RMj4NdEbMIxh2PDzbhUWgmcdzRXY8RxcQNN/bbGOW5Q=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    aiohttp
    bitstruct
    cryptography
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
