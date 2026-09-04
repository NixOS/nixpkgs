{
  lib,
  buildPythonPackage,
  cryptography,
  fetchPypi,
  fonttools,
  lxml,
  pillow,
  python-barcode,
  qrcode,
  requests,
  setuptools,
}:

buildPythonPackage rec {
  pname = "borb";
  version = "2.1.25";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-gTolInuW9HHSkkS/PAens9821h1ivL7PRbFJRLgBHvQ=";
  };

  build-system = [ setuptools ];

  dependencies = [
    cryptography
    fonttools
    lxml
    pillow
    python-barcode
    qrcode
    requests
    setuptools
  ];

  # Tests are not included in the PyPI source distribution.
  doCheck = false;

  pythonImportsCheck = [
    "borb.pdf"
    "borb.pdf.canvas.layout.table.fixed_column_width_table"
  ];

  meta = {
    description = "Library for reading, creating and manipulating PDF files";
    homepage = "https://borbpdf.com/";
    changelog = "https://github.com/jorisschellekens/borb/releases/tag/v${version}";
    license = lib.licenses.agpl3Plus;
    maintainers = [ lib.maintainers.samuela ];
  };
}
