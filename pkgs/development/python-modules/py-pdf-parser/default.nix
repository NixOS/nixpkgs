{ lib
, buildPythonPackage
, docopt
, fetchPypi
, pdfminer-six
, pythonOlder
, pythonRelaxDepsHook
, setuptools
, wand
}:

buildPythonPackage rec {
  pname = "py-pdf-parser";
  version = "0.11.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-GsiGBigvtAgrM0sRffZBG2tVoEaDai+eUxXhMXWNBr0=";
  };

  nativeBuildInputs = [
    setuptools
    pythonRelaxDepsHook
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
    description = "A tool to help extracting information from structured PDFs";
    homepage = "https://github.com/jstockwin/py-pdf-parser";
    changelog = "https://github.com/jstockwin/py-pdf-parser/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = [ maintainers.marsam ];
  };
}
