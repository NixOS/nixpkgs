{ lib
, buildPythonPackage
, fetchPypi
, setuptools
, docutils
, importlib-metadata
, jinja2
, packaging
, pygments
, pyyaml
, reportlab
, smartypants
, pillow
, pytestCheckHook
, pymupdf
, sphinx
}:

buildPythonPackage rec {
  pname = "rst2pdf";
  version = "0.100";

  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-Zkw8FubT3qJ06ECkNurE26bLUKtq8xYvydVxa+PLe0I=";
  };

  outputs = [ "out" "man" ];

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    docutils
    importlib-metadata
    jinja2
    packaging
    pygments
    pyyaml
    reportlab
    smartypants
    pillow
  ];

  pythonImportsCheck = [
    "rst2pdf"
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pymupdf
    sphinx
  ];

  # Test suite fails: https://github.com/rst2pdf/rst2pdf/issues/1067
  doCheck = false;

  postInstall = ''
    mkdir -p $man/share/man/man1/
    ${docutils}/bin/rst2man.py doc/rst2pdf.rst $man/share/man/man1/rst2pdf.1
  '';

  meta = with lib; {
    description = "Convert reStructured Text to PDF via ReportLab";
    homepage = "https://rst2pdf.org/";
    license = licenses.mit;
    maintainers = with maintainers; [ marsam ];
  };
}
