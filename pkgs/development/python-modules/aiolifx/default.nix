{ lib
, fetchPypi
, buildPythonPackage
, isPy3k
, ifaddr
, bitstring
}:

buildPythonPackage rec {
  pname = "aiolifx";
  version = "0.6.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0c28e9c058ee504a07eec11cb333bc6496d233da100dcab9c33549e9eb4985c0";
  };

  # tests are not implemented
  doCheck = false;

  disabled = !isPy3k;

  propagatedBuildInputs = [ bitstring ifaddr ];

  meta = with lib; {
    homepage = "https://github.com/frawau/aiolifx";
    license = licenses.mit;
    description = "API for local communication with LIFX devices over a LAN with asyncio";
    maintainers = with maintainers; [ netixx ];
  };
}
