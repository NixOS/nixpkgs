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
  pytest-cov,
  pytest-parallel,
  pytestCheckHook,
  types-pillow,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage rec {
  pname = "pdfplumber";
  version = "0.11.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jsvine";
    repo = "pdfplumber";
    tag = "v${version}";
    hash = "sha256-ljoM252w0oOqTUgYT6jtAW+jElPU9a49K6Atwdv5Dvo=";
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
    pytest-cov
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
    changelog = "https://github.com/jsvine/pdfplumber/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ happysalada ];
  };
}
