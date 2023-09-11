{ lib
, buildPythonPackage
, fetchPypi
, setuptools
, setuptools-scm
, wheel
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
  version = "0.101";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-AF8FssEIFHmeY2oVrAPNe85pbmgKWO52yD6ycNNzTSg=";
  };

  outputs = [ "out" "man" ];

  nativeBuildInputs = [
    setuptools
    setuptools-scm
    wheel
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
    changelog = "https://github.com/rst2pdf/rst2pdf/blob/${version}/CHANGES.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ marsam ];
  };
}
