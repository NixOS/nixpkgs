{
  lib,
  buildPythonPackage,
  docstring-parser,
  fetchFromGitHub,
  hatch-vcs,
  hatchling,
  napari, # a reverse-dependency, for tests
  psygnal,
  pyside2,
  pyside6,
  pyqt6,
  pyqt5,
  pytestCheckHook,
  superqt,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "magicgui";
  version = "0.10.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pyapp-kit";
    repo = "magicgui";
    tag = "v${version}";
    hash = "sha256-jpM5OpQ10cF+HBhAI9cI/gXdHMzYsgY9vtpfNq+5fIw=";
  };

  build-system = [
    hatch-vcs
    hatchling
  ];

  dependencies = [
    typing-extensions
    superqt
    psygnal
    docstring-parser
  ];

  optional-dependencies = {
    pyside2 = [ pyside2 ];
    pyside6 = [ pyside6 ];
    pyqt6 = [ pyqt6 ];
    pyqt5 = [ pyqt5 ];
  };

  nativeCheckInputs = [ pytestCheckHook ];

  doCheck = false; # Reports "Fatal Python error"

  passthru.tests = {
    inherit napari;
  };

  meta = {
    description = "Build GUIs from python functions, using magic.  (napari/magicgui)";
    homepage = "https://github.com/pyapp-kit/magicgui";
    changelog = "https://github.com/pyapp-kit/magicgui/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ SomeoneSerge ];
  };
}
