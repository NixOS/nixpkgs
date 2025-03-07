{
  lib,
  buildPythonPackage,
  docopt,
  fetchPypi,
  pdfminer-six,
  pythonOlder,
  setuptools,
  wand,
}:

buildPythonPackage rec {
  pname = "py-pdf-parser";
  version = "0.12.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-nMEmzQVz1LR4omHyxhvrjBXDQQE23S62T0wxZeMnXhg=";
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

  meta = with lib; {
    description = "Tool to help extracting information from structured PDFs";
    homepage = "https://github.com/jstockwin/py-pdf-parser";
    changelog = "https://github.com/jstockwin/py-pdf-parser/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = [ ];
  };
}
