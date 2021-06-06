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
  version = "0.4";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "exxamalte";
    repo = "python-aio-georss-gdacs";
    rev = "v${version}";
    sha256 = "0rcrhdpgj84hfifx9rzxz15ajzsk069iknb28gicw1cm1qv4vfxm";
  };

  propagatedBuildInputs = [
    aio-georss-client
    dateparser
  ];

  checkInputs = [
    aresponses
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "aio_georss_gdacs" ];

  meta = with lib; {
    description = "Python library for accessing GeoRSS feeds";
    homepage = "https://github.com/exxamalte/python-aio-georss-gdacs";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
