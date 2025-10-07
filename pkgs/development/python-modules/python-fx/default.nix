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
  pythonOlder,
  antlr4,
  pyyaml,
  setuptools,
  urwid,
  parameterized,
  wcwidth,
  yamale,
}:

buildPythonPackage rec {
  pname = "python-fx";
  version = "0.3.2";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "cielong";
    repo = "pyfx";
    tag = "v${version}";
    hash = "sha256-Q5ihWnoa7nf4EkrY4SgrwjaNvTva4RdW9GRbnbsPXPc=";
  };

  postPatch = ''
    rm src/pyfx/model/common/jsonpath/*.py # upstream checks in generated files, remove to ensure they were regenerated
    antlr -Dlanguage=Python3 -visitor src/pyfx/model/common/jsonpath/*.g4
    rm src/pyfx/model/common/jsonpath/*.{g4,interp,tokens} # no need to install

    # https://github.com/cielong/pyfx/pull/148
    substituteInPlace src/pyfx/view/common/frame.py \
      --replace-fail "self.__super.__init__()" "super().__init__()"
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

  meta = with lib; {
    description = "Module to view JSON in a TUI";
    homepage = "https://github.com/cielong/pyfx";
    changelog = "https://github.com/cielong/pyfx/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
    mainProgram = "pyfx";
  };
}
