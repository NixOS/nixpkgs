{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build-system
  setuptools,

  # dependencies
  cryptography,
  fonttools,
  lxml,
  pillow,
  python-barcode,
  qrcode,
  requests,
}:

buildPythonPackage (finalAttrs: {
  pname = "borb";
  version = "2.1.25";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
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
    changelog = "https://github.com/jorisschellekens/borb/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.agpl3Plus;
    maintainers = [ lib.maintainers.samuela ];
  };
})
