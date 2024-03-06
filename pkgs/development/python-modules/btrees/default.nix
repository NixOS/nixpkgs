{ lib
, fetchPypi
, buildPythonPackage
, persistent
, zope-interface
, transaction
, zope-testrunner
, python
, pythonOlder
}:

buildPythonPackage rec {
  pname = "btrees";
  version = "5.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "BTrees";
    inherit version;
    hash = "sha256-raDzHpMloEeV0dJOAn7ZsrZdpNZqz/i4eVWzUo1/w2k=";
  };

  propagatedBuildInputs = [
    persistent
    zope-interface
  ];

  nativeCheckInputs = [
    transaction
    zope-testrunner
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
