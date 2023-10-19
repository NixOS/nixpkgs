{ lib
, async-timeout
, click
, fetchPypi
, buildPythonPackage
, pythonOlder
, ifaddr
, inquirerpy
, bitstring
}:

buildPythonPackage rec {
  pname = "aiolifx";
  version = "0.9.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-oK8Ih62EFwu3X5PNVFLH+Uce6ZBs7IMXet5/DHxfd5M=";
  };

  propagatedBuildInputs = [
    async-timeout
    bitstring
    click
    ifaddr
    inquirerpy
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [
    "aiolifx"
  ];

  meta = with lib; {
    description = "Module for local communication with LIFX devices over a LAN";
    homepage = "https://github.com/frawau/aiolifx";
    changelog = "https://github.com/frawau/aiolifx/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ netixx ];
  };
}
