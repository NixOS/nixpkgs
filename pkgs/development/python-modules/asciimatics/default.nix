{ lib
, buildPythonPackage
, fetchPypi
, pillow
, pyfiglet
, pytestCheckHook
, pythonOlder
, setuptools-scm
, wcwidth
}:

buildPythonPackage rec {
  pname = "asciimatics";
  version = "1.15.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-z905gEJydRnYtz5iuO+CwL7P7U60IImcO5bJjQuWgho=";
  };

  build-system = [
    setuptools-scm
  ];

  dependencies = [
    pyfiglet
    pillow
    wcwidth
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck =  [
    "asciimatics.effects"
    "asciimatics.renderers"
    "asciimatics.scene"
    "asciimatics.screen"
  ];

  meta = with lib; {
    description = "Module to create full-screen text UIs (from interactive forms to ASCII animations)";
    homepage = "https://github.com/peterbrittain/asciimatics";
    changelog = "https://github.com/peterbrittain/asciimatics/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ cmcdragonkai ];
  };
}
