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
}:

buildPythonPackage rec {
  pname = "pudb";
  version = "2025.1.5";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-5t7bgfw8jNzWbPYuhjN8uRNXDrssmUyatSAS0Fnghq0=";
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

  meta = {
    description = "Full-screen, console-based Python debugger";
    mainProgram = "pudb";
    homepage = "https://github.com/inducer/pudb";
    changelog = "https://github.com/inducer/pudb/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
