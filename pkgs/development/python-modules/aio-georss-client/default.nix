{ lib
, aiohttp
, aresponses
, buildPythonPackage
, dateparser
, fetchFromGitHub
, haversine
, mock
, pytest-asyncio
, pytestCheckHook
, pythonOlder
, requests
, xmltodict
}:

buildPythonPackage rec {
  pname = "aio-georss-client";
  version = "0.11";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "exxamalte";
    repo = "python-aio-georss-client";
    rev = "refs/tags/v${version}";
    hash = "sha256-Voc1ME0iGQCMaDfBXDSVnRp8olvId+fLhH8sqHwB2Ak=";
  };

  propagatedBuildInputs = [
    aiohttp
    haversine
    xmltodict
    requests
    dateparser
  ];

  nativeCheckInputs = [
    aresponses
    mock
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "aio_georss_client"
  ];

  meta = with lib; {
    description = "Python library for accessing GeoRSS feeds";
    homepage = "https://github.com/exxamalte/python-aio-georss-client";
    changelog = "https://github.com/exxamalte/python-aio-georss-client/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
