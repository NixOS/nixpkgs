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
  version = "1.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f78ec32249a0e7a9807a01202caabc8aa11359fd920afb66783662e5cc554890";
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
