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
  version = "0.7";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "exxamalte";
    repo = "python-aio-georss-gdacs";
    rev = "v${version}";
    sha256 = "sha256-6z0l0PcFTQgOBj8cBgBMPJIqWG53u7h4WbYkBqU4FNE=";
  };

  propagatedBuildInputs = [
    aio-georss-client
    dateparser
  ];

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
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
