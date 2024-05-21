{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "fpdf";
  version = "1.7.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0yb73c2clv581sgak5jvlvkj4wy3jav6ms5ia8jx3rw969w40n0j";
  };

  # No tests available
  doCheck = false;

  meta = {
    homepage = "https://github.com/reingart/pyfpdf";
    description = "Simple PDF generation for Python";
    license = lib.licenses.lgpl3;
    maintainers = with lib.maintainers; [ oxzi ];
  };
}
