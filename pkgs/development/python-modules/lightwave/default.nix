{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
}:

buildPythonPackage rec {
  pname = "lightwave";
  version = "0.21";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-h/ztEY473XjvUCWu6vr7FA3WSYPHaLKNMc2fpu/wRC0=";
  };

  pythonImportsCheck = [
    "lightwave"
  ];

  # Requires phyiscal hardware
  doCheck = false;

  meta = with lib; {
    description = "Module for interacting with LightwaveRF hubs";
    homepage = "https://github.com/GeoffAtHome/lightwave";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
