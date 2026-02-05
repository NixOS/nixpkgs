{
  lib,
  buildPythonPackage,
  docopt,
  fetchPypi,
  pdfminer-six,
  setuptools,
  wand,
}:

buildPythonPackage rec {
  pname = "py-pdf-parser";
  version = "0.13.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-dssxWgbMrWFTK4b7oBezF77k9NmUTbdbQED9eyVQGlU=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    docopt
    pdfminer-six
    wand
  ];

  pythonRelaxDeps = [
    "docopt"
    "pdfminer.six"
    "wand"
  ];

  # needs pyvoronoi, which isn't packaged yet
  doCheck = false;

  pythonImportsCheck = [
    "py_pdf_parser"
    "py_pdf_parser.loaders"
  ];

  meta = {
    description = "Tool to help extracting information from structured PDFs";
    homepage = "https://github.com/jstockwin/py-pdf-parser";
    changelog = "https://github.com/jstockwin/py-pdf-parser/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
