{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  setuptools,
  ...
}:
buildPythonPackage rec {
  pname = "libregf-python";
  version = "20240421";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-oYbCR1zX59Cj4yQbM1fk5SC/YFB14BmiL0F4mix0Gvw=";
  };

  build-system = [ setuptools ];

  disabled = pythonOlder "3.7";

  pythonImportsCheck = [ "pyregf" ];

  meta = with lib; {
    changelog = "https://github.com/libyal/libregf/releases/tag/${version}";
    description = "Python bindings module for libregf";
    downloadPage = "https://github.com/libyal/libregf/releases";
    homepage = "https://github.com/libyal/libregf";
    license = licenses.lgpl3Plus;
    maintainers = [ maintainers.jayrovacsek ];
  };
}
