{ lib
, fetchPypi
, buildPythonPackage
, pythonOlder
, ifaddr
, bitstring
}:

buildPythonPackage rec {
  pname = "aiolifx";
  version = "0.7.1";

  disabled = pythonOlder "3.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-ktXnAgrxfDELfMQATcWHn/u6C4bKQii+mbT4mA54coo=";
  };

  propagatedBuildInputs = [
    bitstring
    ifaddr
  ];

  # tests are not implemented
  doCheck = false;

  pythonImportsCheck = [ "aiolifx" ];

  meta = with lib; {
    description = "API for local communication with LIFX devices over a LAN";
    homepage = "https://github.com/frawau/aiolifx";
    license = licenses.mit;
    maintainers = with maintainers; [ netixx ];
  };
}
