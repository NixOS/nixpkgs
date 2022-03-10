{ lib
, fetchPypi
, buildPythonPackage
, persistent
, zope_interface
, transaction
, zope_testrunner
, python
}:

buildPythonPackage rec {
  pname = "BTrees";
  version = "4.10.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-1qsONBDQdNcVQkXW3GSTrobxtQvWCA0TEOuz7N6l3rY=";
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
