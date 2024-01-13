{ lib
, buildPythonPackage
, fetchFromGitHub
, jupyterlab
, nbexec
, pandas
, pandas-stubs
, pdfminer-six
, pillow
, pytest-parallel
, pytestCheckHook
, pythonOlder
, types-pillow
, wand
}:

buildPythonPackage rec {
  pname = "pdfplumber";
  version = "0.10.3";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "jsvine";
    repo = "pdfplumber";
    rev = "refs/tags/v${version}";
    hash = "sha256-fd/4I6jjc0Wz2+XHGXAGg0Am3Dmw9R2ZX7nymIj/UnA=";
  };

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "--cov=pdfplumber --cov-report xml:coverage.xml --cov-report term" ""
  '';

  propagatedBuildInputs = [
    pdfminer-six
    pillow
    wand
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  nativeCheckInputs = [
    jupyterlab
    nbexec
    pandas
    pandas-stubs
    pytest-parallel
    pytestCheckHook
    types-pillow
  ];

  pythonImportsCheck = [
    "pdfplumber"
  ];

  disabledTests = [
    # flaky
    "test__repr_png_"
  ];

  disabledTestPaths = [
    # Tests requires pypdfium2
    "tests/test_display.py"
    # Tests require Ghostscript
    "tests/test_repair.py"
  ];

  meta = with lib; {
    description = "Plumb a PDF for detailed information about each char, rectangle, line, et cetera — and easily extract text and tables";
    homepage = "https://github.com/jsvine/pdfplumber";
    changelog = "https://github.com/jsvine/pdfplumber/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ happysalada ];
  };
}
