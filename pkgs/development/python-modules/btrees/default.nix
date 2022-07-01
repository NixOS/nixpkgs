{ lib
, fetchPypi
, buildPythonPackage
, persistent
, zope_interface
, transaction
, zope_testrunner
, python
, pythonOlder
}:

buildPythonPackage rec {
  pname = "btrees";
  version = "4.10.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "BTrees";
    inherit version;
    hash = "sha256-1qsONBDQdNcVQkXW3GSTrobxtQvWCA0TEOuz7N6l3rY=";
  };

  propagatedBuildInputs = [
    persistent
    zope_interface
  ];

  checkInputs = [
    transaction
    zope_testrunner
  ];

  checkPhase = ''
    runHook preCheck
    ${python.interpreter} -m zope.testrunner --test-path=src --auto-color --auto-progress
    runHook postCheck
  '';

  pythonImportsCheck = [
    "BTrees.OOBTree"
    "BTrees.IOBTree"
    "BTrees.IIBTree"
    "BTrees.IFBTree"
  ];

  meta = with lib; {
    description = "Scalable persistent components";
    homepage = "http://packages.python.org/BTrees";
    license = licenses.zpl21;
    maintainers = with maintainers; [ ];
  };
}
