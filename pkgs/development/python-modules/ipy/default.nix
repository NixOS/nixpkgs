{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "ipy";
  version = "1.2";
  pyproject = true;

  src = fetchPypi {
    pname = "ipy";
    inherit version;
    hash = "sha256-wUXmZOhGQvrIdaBD+rGgtQvWUpc4XcQ42/4l8k5lrGE=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "IPy" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Class and tools for handling of IPv4 and IPv6 addresses and networks";
    homepage = "https://github.com/autocracy/python-ipy";
    license = lib.licenses.bsdOriginal;
  };
}
