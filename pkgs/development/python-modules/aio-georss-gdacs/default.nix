{ lib
, aio-georss-client
, aresponses
, buildPythonPackage
, dateparser
, fetchFromGitHub
, pytest-asyncio
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "aio-georss-gdacs";
  version = "0.8";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "exxamalte";
    repo = "python-aio-georss-gdacs";
    rev = "refs/tags/v${version}";
    hash = "sha256-1mpOWd4Z2gTQtRewWfZsfEtmS6i5uMPAMTlC8UpawxM=";
  };

  propagatedBuildInputs = [
    aio-georss-client
    dateparser
  ];

  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = [
    aresponses
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "aio_georss_gdacs"
  ];

  meta = with lib; {
    description = "Python library for accessing GeoRSS feeds";
    homepage = "https://github.com/exxamalte/python-aio-georss-gdacs";
    changelog = "https://github.com/exxamalte/python-aio-georss-gdacs/releases/tag/v${version}";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
