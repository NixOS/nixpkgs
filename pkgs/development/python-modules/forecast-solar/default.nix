{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pythonOlder,
  aiodns,
  aiohttp,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "forecast-solar";
  version = "3.1.0";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "home-assistant-libs";
    repo = "forecast_solar";
    rev = "refs/tags/v${version}";
    hash = "sha256-iol0XtfPZI95o/uEyBcXgeQjcfl2kI+4mugtywa6BXI=";
  };

  build-system = [ setuptools ];

  env.PACKAGE_VERSION = version;

  dependencies = [
    aiodns
    aiohttp
  ];

  pythonImportsCheck = [ "forecast_solar" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    changelog = "https://github.com/home-assistant-libs/forecast_solar/releases/tag/v${version}";
    description = "Asynchronous Python client for getting forecast solar information";
    homepage = "https://github.com/home-assistant-libs/forecast_solar";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
