{
  lib,
  aiohttp,
  aiozoneinfo,
  arrow,
  buildPythonPackage,
  cryptography,
  fetchFromGitHub,
  pyotp,
  python-dotenv,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "opower";
  version = "0.8.6";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "tronikos";
    repo = "opower";
    rev = "refs/tags/v${version}";
    hash = "sha256-3GzShdYNfaBxu1azPW8eUR5rDn8rrGiE/MhTmwzLOg8=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    aiozoneinfo
    arrow
    cryptography
    pyotp
  ];

  nativeCheckInputs = [
    pytestCheckHook
    python-dotenv
  ];

  pythonImportsCheck = [ "opower" ];

  meta = with lib; {
    description = "Module for getting historical and forecasted usage/cost from utilities that use opower.com";
    homepage = "https://github.com/tronikos/opower";
    changelog = "https://github.com/tronikos/opower/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
