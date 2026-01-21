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
  version = "6.5";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-RwkiFZZTKYZRBcSMFSTp0mF6o88INaxiXDeUBPbL298=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools < 74" "setuptools"
  '';

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
