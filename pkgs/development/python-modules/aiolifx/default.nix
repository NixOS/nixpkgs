{ lib
, fetchPypi
, buildPythonPackage
, pythonOlder
, ifaddr
, bitstring
}:

buildPythonPackage rec {
  pname = "aiolifx";
  version = "0.8.4";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-r5bBomAoRwlII8pT/2o+0va/oBr3s8b8v2jq9n6WDwI=";
  };

  propagatedBuildInputs = [
    bitstring
    ifaddr
  ];

  # tests are not implemented
  doCheck = false;

  pythonImportsCheck = [
    "aiolifx"
  ];

  meta = with lib; {
    description = "Module for local communication with LIFX devices over a LAN";
    homepage = "https://github.com/frawau/aiolifx";
    license = licenses.mit;
    maintainers = with maintainers; [ netixx ];
  };
}
