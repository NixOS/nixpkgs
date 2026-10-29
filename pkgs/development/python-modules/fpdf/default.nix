{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage (finalAttrs: {
  pname = "fpdf";
  version = "1.7.2";
  format = "setuptools";

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-ElhAeDKJ59ElUrHoaraSw3Mi56ZblqmeDqhsygQbZ3k=";
  };

  # No tests available
  doCheck = false;

  meta = {
    homepage = "https://github.com/reingart/pyfpdf";
    description = "Simple PDF generation for Python";
    license = lib.licenses.lgpl3;
    maintainers = [ ];
  };
})
