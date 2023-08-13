{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
# build inputs
, pdfminer-six
, pillow
, wand
# check inputs
, pytestCheckHook
, pytest-cov
, pytest-parallel
, flake8
, black
, isort
, pandas
, mypy
, pandas-stubs
, types-pillow
, jupyterlab
, nbexec
}:
let
  pname = "pdfplumber";
  version = "0.9.0";
in
buildPythonPackage {
  inherit pname version;
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "jsvine";
    repo = "pdfplumber";
    rev = "refs/tags/v${version}";
    hash = "sha256-cGTn1JTSp1YvksemjlvvToZcVauZ7GKINiNmG5f4zKg=";
  };

  propagatedBuildInputs = [
    pdfminer-six
    pillow
    wand
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov
    pytest-parallel
    flake8
    black
    isort
    pandas
    mypy
    pandas-stubs
    types-pillow
    jupyterlab
    nbexec
  ];

  pythonImportsCheck = [
    "pdfplumber"
  ];

  disabledTests = [
    # flaky
    "test__repr_png_"
  ];

  meta = with lib; {
    description = "Plumb a PDF for detailed information about each char, rectangle, line, et cetera — and easily extract text and tables.";
    homepage = "https://github.com/jsvine/pdfplumber";
    changelog = "https://github.com/jsvine/pdfplumber/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ happysalada ];
  };
}
