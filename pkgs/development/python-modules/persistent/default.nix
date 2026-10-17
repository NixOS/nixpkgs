{
  lib,
  buildPythonPackage,
  fetchPypi,
  isPyPy,

  # build-systems
  setuptools,

  # dependencies
  cffi,
  zope-deferredimport,
  zope-interface,
}:

buildPythonPackage rec {
  pname = "persistent";
  version = "6.8";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-LnzKobGrU0a+kDmAv3SsMB5ae+TmlJyTz58qcWrdixg=";
  };

  build-system = [ setuptools ];

  dependencies = [
    zope-interface
    zope-deferredimport
  ]
  ++ lib.optionals (!isPyPy) [ cffi ];

  pythonImportsCheck = [ "persistent" ];

  meta = {
    description = "Automatic persistence for Python objects";
    homepage = "https://github.com/zopefoundation/persistent/";
    changelog = "https://github.com/zopefoundation/persistent/blob/${version}/CHANGES.rst";
    license = lib.licenses.zpl21;
    maintainers = [ ];
  };
}
