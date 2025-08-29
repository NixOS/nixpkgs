{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pyside6,
  pysidesix-frameless-window,
  darkdetect,
}:

buildPythonPackage rec {
  pname = "pyside6-fluent-widgets";
  version = "1.8.4";
  pyproject = true;

  src = fetchPypi {
    pname = "pyside6_fluent_widgets";
    inherit version;
    hash = "sha256-DtyldvNqdjca0Os2au1WSqyH9gLkQt8ryNrunZuUEus=";
  };

  build-system = [ setuptools ];

  dependencies = [
    pyside6
    pysidesix-frameless-window
    darkdetect
  ];

  # no tests
  doCheck = false;

  pythonImportsCheck = [ "qfluentwidgets" ];

  meta = {
    description = "Fluent design widgets library based on PySide6";
    homepage = "https://github.com/zhiyiYo/PyQt-Fluent-Widgets";
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ ];
  };
}
