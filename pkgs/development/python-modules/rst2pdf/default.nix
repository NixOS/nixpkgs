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
  version = "0.99";

  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8fa23fa93bddd1f52d058ceaeab6582c145546d80f2f8a95974f3703bd6c8152";
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
