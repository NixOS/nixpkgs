{
  lib,
  aio-georss-client,
  aioresponses,
  buildPythonPackage,
  fetchFromGitHub,
  pytest-asyncio,
  pytestCheckHook,
  python-dateutil,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "aio-georss-gdacs";
  version = "0.10";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "exxamalte";
    repo = "python-aio-georss-gdacs";
    tag = "v${version}";
    hash = "sha256-PhOI0v3dKTNGZLk1/5wIgvQkm4Cwfr1UYilr5rW7e3g=";
  };

  __darwinAllowLocalNetworking = true;

  build-system = [ setuptools ];

  dependencies = [
    aio-georss-client
    python-dateutil
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
