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
  version = "6.5";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-GHbK0OvKw/aNrc3KgBjqbLdrM0+Zkac6qFy7DLj9jPA=";
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

  meta = {
    description = "Scalable persistent components";
    homepage = "http://packages.python.org/BTrees";
    changelog = "https://github.com/zopefoundation/BTrees/blob/${version}/CHANGES.rst";
    license = lib.licenses.zpl21;
    maintainers = [ ];
  };
}
