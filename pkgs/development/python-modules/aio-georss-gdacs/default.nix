{
  lib,
  aio-georss-client,
  aioresponses,
  buildPythonPackage,
  dateparser,
  fetchFromGitHub,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "aio-georss-gdacs";
  version = "0.9";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "exxamalte";
    repo = "python-aio-georss-gdacs";
    rev = "refs/tags/v${version}";
    hash = "sha256-B0qVCh2u0WleF0iv0o1/d5UIS2kbYCAqCgmNHyCpJ8Q=";
  };

  __darwinAllowLocalNetworking = true;

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    aio-georss-client
    dateparser
  ];

  nativeCheckInputs = [
    aioresponses
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "aio_georss_gdacs" ];

  meta = with lib; {
    description = "Python library for accessing GeoRSS feeds";
    homepage = "https://github.com/exxamalte/python-aio-georss-gdacs";
    changelog = "https://github.com/exxamalte/python-aio-georss-gdacs/releases/tag/v${version}";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
