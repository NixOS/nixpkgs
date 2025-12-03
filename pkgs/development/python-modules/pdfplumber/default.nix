{
  pkgs,
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  jupyterlab,
  nbexec,
  pandas,
  pandas-stubs,
  pdfminer-six,
  pillow,
  pypdfium2,
  pytest-cov-stub,
  pytest-parallel,
  pytestCheckHook,
  types-pillow,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage rec {
  pname = "pdfplumber";
  version = "0.11.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jsvine";
    repo = "pdfplumber";
    tag = "v${version}";
    hash = "sha256-BTAeZymk6attFVu+2FMYyg8jS911Lyu+H/WuuKGK5KI=";
  };

  build-system = [ setuptools ];

  dependencies = [
    pdfminer-six
    pillow
    pypdfium2
  ];

  nativeCheckInputs = [
    pkgs.ghostscript
    jupyterlab
    nbexec
    pandas
    pandas-stubs
    pytest-cov-stub
    pytest-parallel
    pytestCheckHook
    types-pillow
    writableTmpDirAsHomeHook
  ];

  pythonRelaxDeps = [ "pdfminer.six" ];

  disabledTestPaths = [
    # AssertionError
    "tests/test_convert.py::Test::test_cli_csv"
    "tests/test_convert.py::Test::test_cli_csv_exclude"
    "tests/test_convert.py::Test::test_csv"
  ];

  pythonImportsCheck = [ "pdfplumber" ];

  meta = {
    description = "Plumb a PDF for detailed information about each char, rectangle, line, et cetera — and easily extract text and tables";
    mainProgram = "pdfplumber";
    homepage = "https://github.com/jsvine/pdfplumber";
    changelog = "https://github.com/jsvine/pdfplumber/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ happysalada ];
  };
}
