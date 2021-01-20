{ lib
, bitstring
, buildPythonPackage
, fetchPypi
, ifaddr
, isPy3k
}:

buildPythonPackage rec {
  pname = "aiolifx";
  version = "0.6.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-DCjpwFjuUEoH7sEcszO8ZJbSM9oQDcq5wzVJ6etJhcA=";
  };

  # tests are not implemented
  doCheck = false;
  pythonImportsCheck = [ "aiolifx" ];

  disabled = !isPy3k;

  propagatedBuildInputs = [ bitstring ifaddr ];

  meta = with lib; {
    homepage = "https://github.com/frawau/aiolifx";
    license = licenses.mit;
    description = "Python API for local communication with LIFX devices over a LAN";
    maintainers = with maintainers; [ netixx ];
  };
}
