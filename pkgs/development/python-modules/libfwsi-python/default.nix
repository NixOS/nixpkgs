{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  setuptools,
  ...
}:
buildPythonPackage rec {
  pname = "libfwsi-python";
  version = "20240423";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-2lgCmNhsSr8uD4Ed5scw+BWSxhxCt+d/jyrwZSVaKEM=";
  };

  build-system = [ setuptools ];

  disabled = pythonOlder "3.7";

  pythonImportsCheck = [ "pyfwsi" ];

  meta = with lib; {
    changelog = "https://github.com/libyal/libfwsi/releases/tag/${version}";
    description = "Python bindings module for libfwsi";
    downloadPage = "https://github.com/libyal/libfwsi/releases";
    homepage = "https://github.com/libyal/libfwsi";
    license = licenses.lgpl3Plus;
    maintainers = [ maintainers.jayrovacsek ];
  };
}
