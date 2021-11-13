{ lib
, buildPythonPackage
, fetchPypi
, pytest-mock
, pytestCheckHook
, python-dateutil
, pythonOlder
, setuptools-scm
, urllib3
}:

buildPythonPackage rec {
  pname = "amberelectric";
  version = "1.0.3";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1hsbk2v7j1nsa083j28jb7b3rv76flan0g9wav97qccp1gjds5b0";
  };

  propagatedBuildInputs = [
    urllib3
    python-dateutil
  ];

  checkInputs = [
    pytest-mock
    pytestCheckHook
  ];

  pythonImportsCheck = [ "amberelectric" ];

  meta = with lib; {
    description = "Python Amber Electric API interface";
    homepage = "https://github.com/madpilot/amberelectric.py";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
