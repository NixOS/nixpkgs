{
  lib,
  buildPythonPackage,
  fetchPypi,
  pillow,
  pyfiglet,
  pytestCheckHook,
  setuptools-scm,
  wcwidth,
}:

buildPythonPackage rec {
  pname = "asciimatics";
  version = "1.15.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-z905gEJydRnYtz5iuO+CwL7P7U60IImcO5bJjQuWgho=";
  };

  build-system = [ setuptools-scm ];

  dependencies = [
    pyfiglet
    pillow
    wcwidth
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [
    "asciimatics.effects"
    "asciimatics.renderers"
    "asciimatics.scene"
    "asciimatics.screen"
  ];

  meta = {
    description = "Module to create full-screen text UIs (from interactive forms to ASCII animations)";
    homepage = "https://github.com/peterbrittain/asciimatics";
    changelog = "https://github.com/peterbrittain/asciimatics/releases/tag/${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ cmcdragonkai ];
  };
}
