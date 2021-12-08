{ lib
, fetchFromGitHub
, buildPythonPackage
, pythonOlder
, ifaddr
, bitstring
}:

buildPythonPackage rec {
  pname = "aiolifx";
  version = "0.7.0";

  disabled = pythonOlder "3.4";

  src = fetchFromGitHub {
     owner = "frawau";
     repo = "aiolifx";
     rev = "0.7.0";
     sha256 = "10zyfpd5n607rpd07an15sh2vxdp1jm2d2adafl5mn9v8d72pwfm";
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
