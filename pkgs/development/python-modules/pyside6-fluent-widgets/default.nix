{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pyside6,
  pysidesix-frameless-window,
  darkdetect,
}:

buildPythonPackage {
  pname = "pyside6-fluent-widgets";
  version = "1.8.1-unstable-2025-06-01";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "zhiyiYo";
    repo = "PyQt-Fluent-Widgets";
    rev = "54acf49fe50578a7a2d0ca2aa834753f8081411c";
    hash = "sha256-2O/apyrr1HEXtucviazIucjtIic7Au0FFaxpcuUSvJU=";
  };

  build-system = [ setuptools ];

  dependencies = [
    pyside6
    pysidesix-frameless-window
    darkdetect
  ];

  pythonImportsCheck = [ "qfluentwidgets" ];

  meta = {
    description = "Fluent design widgets library based on PySide6";
    homepage = "https://github.com/zhiyiYo/PyQt-Fluent-Widgets";
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ emaryn ];
  };
}
