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
  version = "4.9.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d33323655924192c4ac998d9ee3002e787915d19c1e17a6baf47c9a63d9556e3";
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
