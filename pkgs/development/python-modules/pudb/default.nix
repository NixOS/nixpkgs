{
  lib,
  buildPythonPackage,
  hatchling,
  fetchPypi,
  jedi,
  packaging,
  pygments,
  urwid,
  urwid-readline,
  pytest-mock,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "pudb";
  version = "2025.1.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-t8JFx1MceSZDYSYgqoErleyAoi/Q5nveTYRzRpLcS3I=";
  };

  build-system = [ hatchling ];

  dependencies = [
    jedi
    packaging
    pygments
    urwid
    urwid-readline
  ];

  nativeCheckInputs = [
    pytest-mock
    pytestCheckHook
  ];

  preCheck = ''
    export HOME=$TMPDIR
  '';

  pythonImportsCheck = [ "pudb" ];

  meta = with lib; {
    description = "Full-screen, console-based Python debugger";
    mainProgram = "pudb";
    homepage = "https://github.com/inducer/pudb";
    changelog = "https://github.com/inducer/pudb/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = [ ];
  };
}
