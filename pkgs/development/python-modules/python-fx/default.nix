{ lib
, antlr4-python3-runtime
, asciimatics
, buildPythonPackage
, click
, dacite
, decorator
, fetchFromGitHub
, future
, first
, jsonpath-ng
, loguru
, overrides
, pillow
, ply
, pyfiglet
, pyperclip
, pytestCheckHook
, pythonOlder
, antlr4
, pythonRelaxDepsHook
, pyyaml
, setuptools
, six
, urwid
, parameterized
, wcwidth
, yamale
}:

buildPythonPackage rec {
  pname = "python-fx";
  version = "0.3.0";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "cielong";
    repo = "pyfx";
    rev = "refs/tags/v${version}";
    hash = "sha256-Bgg6UbAyog1I4F2NfULY+UlPf2HeyBJdxm4+5bmCLN0=";
  };

  postPatch = ''
    rm src/pyfx/model/common/jsonpath/*.{g4,interp,tokens}
    antlr -Dlanguage=Python3 -visitor -o src/pyfx/model/common/jsonpath/ *.g4
  '';

  pythonRelaxDeps = true;

  nativeBuildInputs = [
    antlr4
    pythonRelaxDepsHook
    setuptools
  ];

  propagatedBuildInputs = [
    antlr4-python3-runtime
    asciimatics
    click
    dacite
    decorator
    first
    future
    jsonpath-ng
    loguru
    overrides
    pillow
    ply
    pyfiglet
    pyperclip
    pyyaml
    six
    urwid
    wcwidth
    yamale
  ];

  nativeCheckInputs = [
    pytestCheckHook
    parameterized
  ];

  # antlr4 issue prevents us from running the tests
  # https://github.com/antlr/antlr4/issues/4041
  doCheck = false;

  # pythonImportsCheck = [
  #   "pyfx"
  # ];

  meta = with lib; {
    description = "Module to view JSON in a TUI";
    homepage = "https://github.com/cielong/pyfx";
    changelog = "https://github.com/cielong/pyfx/releases/tag/v${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
