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
    hash = "sha256-/b92NHM+VrcuJ/m85G5FULdaOixCBBQDXK6dnSayNNU=";
  };

  # No tests in PyPI tarball
  doCheck = false;

  meta = {
    description = "QR code generator written purely in Python with SVG, EPS, PNG and terminal output";
    homepage = "https://github.com/mnooner256/pyqrcode";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
