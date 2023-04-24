{ lib
, async-timeout
, fetchPypi
, buildPythonPackage
, pythonOlder
, ifaddr
, bitstring
}:

buildPythonPackage rec {
  pname = "aiolifx";
  version = "0.8.10";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-NiNKFrWxpGkwbb7tFEDD5jZ6ETW20BBIqrdjCsL/DkY=";
  };

  propagatedBuildInputs = [
    async-timeout
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
    changelog = "https://github.com/frawau/aiolifx/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ netixx ];
  };
}
