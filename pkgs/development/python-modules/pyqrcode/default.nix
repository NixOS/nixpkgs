{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "pyqrcode";
  version = "1.2.1";
  format = "setuptools";

  src = fetchPypi {
    pname = "PyQRCode";
    inherit version;
    sha256 = "fdbf7634733e56b72e27f9bce46e4550b75a3a2c420414035cae9d9d26b234d5";
  };

  # No tests in PyPI tarball
  doCheck = false;

  meta = with lib; {
    description = "QR code generator written purely in Python with SVG, EPS, PNG and terminal output";
    homepage = "https://github.com/mnooner256/pyqrcode";
    license = licenses.bsd3;
    maintainers = with maintainers; [ dotlambda ];
  };
}
