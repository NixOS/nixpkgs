{
  lib,
  fetchPypi,
  buildPythonPackage,
  persistent,
  zope-interface,
  transaction,
  zope-testrunner,
  python,
  setuptools,
}:

buildPythonPackage rec {
  pname = "btrees";
  version = "6.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-SnxwN2aEfrD6tYrpudacyAWIy/1uNFcrur1FU+B5/is=";
  };

  build-system = [ setuptools ];

  dependencies = [
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
    changelog = "https://github.com/zopefoundation/BTrees/blob/${version}/CHANGES.rst";
    license = licenses.zpl21;
    maintainers = [ ];
  };
}
