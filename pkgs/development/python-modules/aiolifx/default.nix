{ lib
, fetchPypi
, buildPythonPackage
, isPy3k
, ifaddr
, bitstring
}:

buildPythonPackage rec {
  pname = "aiolifx";
  version = "0.6.10";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b3aaf814dbc03666b22b08103990f260e58616ea64f2a28396653ef3b5fad4f9";
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
