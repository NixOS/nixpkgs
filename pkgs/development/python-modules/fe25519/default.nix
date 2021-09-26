{ lib
, bitlist
, buildPythonPackage
, fetchPypi
, fountains
, parts
, nose
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "fe25519";
  version = "0.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8819659f19b51713199a75fda5107c93fbb6e2cb4afef3164ce7932b5eb276b9";
  };

  propagatedBuildInputs = [
    bitlist
    fountains
    parts
  ];

  checkInputs = [
    nose
    pytestCheckHook
  ];

  pythonImportsCheck = [ "fe25519" ];

  meta = with lib; {
    description = "Python field operations for Curve25519's prime";
    homepage = "https://github.com/BjoernMHaase/fe25519";
    license = with licenses; [ cc0 ];
    maintainers = with maintainers; [ fab ];
  };
}
