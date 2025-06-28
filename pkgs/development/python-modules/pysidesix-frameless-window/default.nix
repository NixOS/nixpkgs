{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pyside6,
}:

buildPythonPackage rec {
  pname = "pysidesix-frameless-window";
  version = "0.7.3";
  pyproject = true;

  src = fetchPypi {
    pname = "pysidesix_frameless_window";
    inherit version;
    hash = "sha256-6a9xyTQOYIo0WWuLXVrOvYGAdoFXJNbR21q4FLyDKEQ=";
  };

  build-system = [ setuptools ];

  dependencies = [ pyside6 ];

  # no tests
  doCheck = false;

  pythonImportsCheck = [ "qframelesswindow" ];

  meta = {
    description = "Frameless window based on PySide6";
    homepage = "https://github.com/zhiyiYo/PyQt-Frameless-Window";
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ emaryn ];
  };
}
