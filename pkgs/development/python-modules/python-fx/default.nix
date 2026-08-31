{
  lib,
  stdenv,
  antlr4-python3-runtime,
  asciimatics,
  buildPythonPackage,
  click,
  dacite,
  decorator,
  fetchFromGitHub,
  first,
  jsonpath-ng,
  loguru,
  overrides,
  pillow,
  ply,
  pyfiglet,
  pyperclip,
  pytestCheckHook,
  antlr4,
  pyyaml,
  setuptools,
  urwid,
  parameterized,
  wcwidth,
  yamale,
}:

buildPythonPackage (finalAttrs: {
  pname = "python-fx";
  version = "0.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cielong";
    repo = "pyfx";
    tag = "v${finalAttrs.version}";
    hash = "sha256-a9gKdM6InH0KP0yrDOo6W90ClMVshbVxLjtiG9yiq1s=";
  };

  postPatch = ''
    rm src/pyfx/model/common/jsonpath/*.py # upstream checks in generated files, remove to ensure they were regenerated
    antlr -Dlanguage=Python3 -visitor src/pyfx/model/common/jsonpath/*.g4
    rm src/pyfx/model/common/jsonpath/*.{g4,interp,tokens} # no need to install
  '';

  pythonRelaxDeps = true;

  build-system = [ setuptools ];

  nativeBuildInputs = [ antlr4 ];

  dependencies = [
    antlr4-python3-runtime
    asciimatics
    click
    dacite
    decorator
    first
    jsonpath-ng
    loguru
    overrides
    pillow
    ply
    pyfiglet
    pyperclip
    pyyaml
    urwid
    wcwidth
    yamale
  ];

  nativeCheckInputs = [
    pytestCheckHook
    parameterized
  ];

  # FAILED tests/test_event_loops.py::TwistedEventLoopTest::test_run - AssertionError: 'callback called with future outcome: True' not found in ['...
  doCheck = !stdenv.hostPlatform.isDarwin;

  pythonImportsCheck = [ "pyfx" ];

  disabledTests = [
    # TypeError: CliRunner.__init__() got an unexpected keyword argument 'mix_stderr'
    "test_start"
  ];

  meta = {
    description = "Module to view JSON in a TUI";
    homepage = "https://github.com/cielong/pyfx";
    changelog = "https://github.com/cielong/pyfx/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "pyfx";
  };
})
