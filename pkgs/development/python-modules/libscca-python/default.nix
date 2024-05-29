{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  setuptools,
  ...
}:
buildPythonPackage rec {
  pname = "libscca-python";
  version = "20240215";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-hes6R8xO0ZlEtalRz0NHaFuW7v0J5P6AKAFSNqoYjWw=";
  };

  build-system = [ setuptools ];

  disabled = pythonOlder "3.7";

  pythonImportsCheck = [ "pyscca" ];

  meta = with lib; {
    changelog = "https://github.com/libyal/libscca/releases/tag/${version}";
    description = "Python bindings module for libscca";
    downloadPage = "https://github.com/libyal/libscca/releases";
    homepage = "https://github.com/libyal/libscca";
    license = licenses.lgpl3Plus;
    maintainers = [ maintainers.jayrovacsek ];
  };
}
