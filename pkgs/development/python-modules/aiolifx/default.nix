{ lib
, fetchPypi
, buildPythonPackage
, isPy3k
, ifaddr
, bitstring
}:

buildPythonPackage rec {
  pname = "aiolifx";
  version = "0.6.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "cf53c9faea6eee25a466e73eef1753b82a75c7497648149c19c15342df2678f2";
  };

  # tests are not implemented
  doCheck = false;

  disabled = !isPy3k;

  propagatedBuildInputs = [ bitstring ifaddr ];

  meta = with lib; {
    homepage = https://github.com/frawau/aiolifx;
    license = licenses.mit;
    description = "API for local communication with LIFX devices over a LAN with asyncio";
    maintainers = with maintainers; [ netixx ];
  };
}
