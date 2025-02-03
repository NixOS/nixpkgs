{
  lib,
  python3Packages,
  fetchPypi,
}:

python3Packages.buildPythonApplication rec {
  pname = "tocpdf";
  version = "0.3.3";
  pyproject = true;

  src = fetchPypi {
    pname = "tocPDF";
    inherit version;
    hash = "sha256-B+UcvyjWceVErf1uDyGGTGwKBCGHmSOF19Vbk15cPp8=";
  };

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies = with python3Packages; [
    click
    pdfplumber
    pypdf
    tika
    tqdm
  ];

  # no test
  doCheck = false;

  pythonImportsCheck = [ "tocPDF" ];

  meta = {
    description = "Automatic CLI tool for generating outline of PDFs based on the table of contents";
    homepage = "https://github.com/kszenes/tocPDF";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dansbandit ];
    mainProgram = "tocPDF";
  };
}
