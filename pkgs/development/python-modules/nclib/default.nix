{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
}:

buildPythonPackage rec {
  pname = "nclib";
  version = "1.0.3";
  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-26KjYMxJMj5ANb2ej9hVl689sAcGHp89QUkH2xiLhZk=";
  };

  # Project has no tests
  doCheck = false;
  pythonImportsCheck = [ "nclib" ];

  meta = with lib; {
    description = "Python module that provides netcat features";
    homepage = "https://nclib.readthedocs.io/";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
