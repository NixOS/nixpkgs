{ lib
, fetchPypi
, buildPythonPackage
, isPy3k
, ifaddr
, bitstring
}:

buildPythonPackage rec {
  pname = "aiolifx";
  version = "0.6.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9f9055bc2a9a72c5eab17e0ce5522edecd6de07e21cf347bf0cffabdabe5570e";
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
