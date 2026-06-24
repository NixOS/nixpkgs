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
  version = "6.7";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-lWhlrgbyOF/FpkOwEk8ZdiSbO33C2rHkbXd/YY+YdN4=";
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
