{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  setuptools,
  zlib,
  ...
}:
buildPythonPackage rec {
  pname = "libqcow-python";
  version = "20240308";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-6bPjrY0uiJu4nVWklso9lzyoAEMBASeGvLr2H5h5YWU=";
  };

  build-system = [ setuptools ];

  buildInputs = [ zlib ];

  disabled = pythonOlder "3.7";

  pythonImportsCheck = [ "pyqcow" ];

  meta = with lib; {
    changelog = "https://github.com/libyal/libqcow/releases/tag/${version}";
    description = "Python bindings module for libqcow";
    downloadPage = "https://github.com/libyal/libqcow/releases";
    homepage = "https://github.com/libyal/libqcow";
    license = licenses.lgpl3Plus;
    maintainers = [ maintainers.jayrovacsek ];
  };
}
