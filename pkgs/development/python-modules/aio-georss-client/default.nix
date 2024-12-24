{
  lib,
  aiohttp,
  aioresponses,
  buildPythonPackage,
  dateparser,
  fetchFromGitHub,
  haversine,
  mock,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
  requests,
  setuptools,
  xmltodict,
}:

buildPythonPackage rec {
  pname = "aio-georss-client";
  version = "0.13";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "exxamalte";
    repo = "python-aio-georss-client";
    rev = "refs/tags/v${version}";
    hash = "sha256-2qo5G/L2yh/6IXswkOyrCYnBNLDLx3EOpR53lnnpNOo=";
  };

  __darwinAllowLocalNetworking = true;

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    haversine
    xmltodict
    requests
    dateparser
  ];

  nativeCheckInputs = [
    aioresponses
    mock
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "aio_georss_client" ];

  meta = with lib; {
    description = "Python library for accessing GeoRSS feeds";
    homepage = "https://github.com/exxamalte/python-aio-georss-client";
    changelog = "https://github.com/exxamalte/python-aio-georss-client/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
