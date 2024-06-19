{
  lib,
  aiohttp,
  aioresponses,
  buildPythonPackage,
  fetchFromGitHub,
  pandas,
  pytestCheckHook,
  requests,
  requests-mock,
  setuptools,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "alpha-vantage";
  version = "2.3.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "RomelTorres";
    repo = "alpha_vantage";
    rev = "refs/tags/${version}";
    hash = "sha256-DWnaLjnbAHhpe8aGUN7JaXEYC0ivWlizOSAfdvg33DM=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    requests
  ];

  nativeCheckInputs = [
    aioresponses
    requests-mock
    pandas
    pytestCheckHook
  ];

  # https://github.com/RomelTorres/alpha_vantage/issues/344
  doCheck = false;

  pythonImportsCheck = [ "alpha_vantage" ];

  meta = with lib; {
    description = "Python module for the Alpha Vantage API";
    homepage = "https://github.com/RomelTorres/alpha_vantage";
    changelog = "https://github.com/RomelTorres/alpha_vantage/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
