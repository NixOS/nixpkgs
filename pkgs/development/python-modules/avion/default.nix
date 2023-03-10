{ lib
, bluepy
, buildPythonPackage
, csrmesh
, fetchPypi
, pycryptodome
, requests
}:

buildPythonPackage rec {
  pname = "avion";
  version = "0.10";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0zgv45086b97ngyqxdp41wxb7hpn9g7alygc21j9y3dib700vzdz";
  };

  propagatedBuildInputs = [
    bluepy
    csrmesh
    pycryptodome
    requests
  ];

  # Project has no test
  doCheck = false;
  # bluepy/uuids.json is not found
  # pythonImportsCheck = [ "avion" ];

  meta = with lib; {
    description = "Python API for controlling Avi-on Bluetooth dimmers";
    homepage = "https://github.com/mjg59/python-avion";
    license = with licenses; [ gpl3Plus ];
    maintainers = with maintainers; [ fab ];
  };
}
