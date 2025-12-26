{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  sortedcontainers,
}:

buildPythonPackage rec {
  pname = "expiring-dict";
  version = "1.1.2";
  pyproject = true;

  src = fetchPypi {
    pname = "expiring_dict";
    inherit version;
    hash = "sha256-yoy4AjBOrlszoj7EwZAZthCt/aUMvEyb+jrVws04djE=";
  };

  build-system = [ setuptools ];

  dependencies = [ sortedcontainers ];

  pythonImportsCheck = [ "expiring_dict" ];

  meta = {
    description = "Python dict with TTL support for auto-expiring caches";
    homepage = "https://github.com/dparker2/py-expiring-dict";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
