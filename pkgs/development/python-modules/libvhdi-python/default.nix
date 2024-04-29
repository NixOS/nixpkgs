{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  setuptools,
  ...
}:
buildPythonPackage rec {
  pname = "libvhdi-python";
  version = "20240303";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-p5Se/gk6g2DdBEYk1IkwAs5VvkTnbq4Xe+7WNlnvKCc=";
  };

  build-system = [ setuptools ];

  disabled = pythonOlder "3.7";

  pythonImportsCheck = [ "pyvhdi" ];

  meta = with lib; {
    changelog = "https://github.com/libyal/libvhdi/releases/tag/${version}";
    description = "Python bindings module for libvhdi";
    downloadPage = "https://github.com/libyal/libvhdi/releases";
    homepage = "https://github.com/libyal/libvhdi";
    license = licenses.lgpl3Plus;
    maintainers = [ maintainers.jayrovacsek ];
  };
}
