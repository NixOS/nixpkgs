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
  version = "2026.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-4yyO7KRwh2mVSBl/EBsf4ZWrgYe5DhcfCjjMCFL8pzw=";
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
