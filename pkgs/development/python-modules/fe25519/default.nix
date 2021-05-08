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
  version = "0.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1m85qvw9dwxk81mv9k45c9n75pk8wqn70qkinqh56h5zv56vgq24";
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
