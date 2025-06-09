{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pyside6,
}:

buildPythonPackage {
  pname = "pysidesix-frameless-window";
  version = "0.7.3-unstable-2025-05-20";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "zhiyiYo";
    repo = "PyQt-Frameless-Window";
    rev = "144990443f9769f8cdd5f97380bfbf967557c911";
    hash = "sha256-0OMOLqsKIuCHTa6hJ3zyzwBfhyMMsOHzEJMCXowb0n4=";
  };

  build-system = [ setuptools ];

  dependencies = [ pyside6 ];

  pythonImportsCheck = [ "qframelesswindow" ];

  meta = {
    description = "Frameless window based on PySide6";
    homepage = "https://github.com/zhiyiYo/PyQt-Frameless-Window";
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ emaryn ];
  };
}
