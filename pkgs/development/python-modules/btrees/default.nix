{
  lib,
  fetchPypi,
  buildPythonPackage,
  persistent,
  zope-interface,
  transaction,
  zope-testrunner,
  python,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "btrees";
  version = "6.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-SnxwN2aEfrD6tYrpudacyAWIy/1uNFcrur1FU+B5/is=";
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
    maintainers = [ ];
  };
}
