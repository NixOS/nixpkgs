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
  version = "1.8.1";
  pyproject = true;

  src = fetchPypi {
    pname = "pyside6_fluent_widgets";
    inherit version;
    hash = "sha256-PMpbGUFN7bb9jKBF+596x4WLqoHjjNN2gX0c4G+lCHo=";
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
    maintainers = with lib.maintainers; [ emaryn ];
  };
}
