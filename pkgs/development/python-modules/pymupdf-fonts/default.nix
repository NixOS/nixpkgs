{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pymupdf-fonts";
  version = "1.0.5";
  pyproject = true;

  src = fetchPypi {
    pname = "pymupdf_fonts";
    inherit version;
    hash = "sha256-rBLj7Er/o16aCsopE170HCO9vldYwzVdrCNphjCea8Y=";
  };

  build-system = [
    setuptools
  ];

  pythonImportsCheck = [ "pymupdf_fonts" ];

  meta = {
    description = "Collection of optional fonts for PyMuPDF";
    homepage = "https://github.com/pymupdf/pymupdf-fonts";
    license = lib.licenses.ofl;
    maintainers = [ ];
  };
}
