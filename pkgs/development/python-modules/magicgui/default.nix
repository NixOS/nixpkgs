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
  pytestCheckHook,
  pythonOlder,
  superqt,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "magicgui";
  version = "0.9.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "pyapp-kit";
    repo = "magicgui";
    rev = "refs/tags/v${version}";
    hash = "sha256-6ye29HtGQ8iwYE2kQ1wWIBC+bzFsMZmJR4eTXWwu7+U=";
  };

  build-system = [
    hatch-vcs
    hatchling
  ];

  dependencies = [
    typing-extensions
    superqt
    pyside2
    psygnal
    docstring-parser
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  doCheck = false; # Reports "Fatal Python error"

  passthru.tests = {
    inherit napari;
  };

  meta = with lib; {
    description = "Build GUIs from python functions, using magic.  (napari/magicgui)";
    homepage = "https://github.com/napari/magicgui";
    changelog = "https://github.com/pyapp-kit/magicgui/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ SomeoneSerge ];
  };
}
