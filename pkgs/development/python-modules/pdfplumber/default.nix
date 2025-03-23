{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  ghostscript,
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
}:

buildPythonPackage rec {
  pname = "pdfplumber";
  version = "0.11.5";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "jsvine";
    repo = "pdfplumber";
    tag = "v${version}";
    hash = "sha256-oe6lZyQKXASzG7Ho6o7mlXY+BOgVBaACebxbYD+1+x0=";
  };

  dependencies = [
    pdfminer-six
    pillow
    pypdfium2
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
    # test_issue_1089 assumes the soft limit on open files is "low", otherwise it never completes
    # reported at: https://github.com/jsvine/pdfplumber/issues/1263
    ulimit -n 1024
  '';

  nativeCheckInputs = [
    ghostscript
    jupyterlab
    nbexec
    pandas
    pandas-stubs
    pytest-cov
    pytest-parallel
    pytestCheckHook
    types-pillow
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
