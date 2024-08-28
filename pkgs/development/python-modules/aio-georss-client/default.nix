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
  version = "0.12";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "exxamalte";
    repo = "python-aio-georss-client";
    rev = "refs/tags/v${version}";
    hash = "sha256-qs0/TkGZlwsucnkgCBco2Pqr9mf5fZHY7ikMBKff+gA=";
  };

  __darwinAllowLocalNetworking = true;

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
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
