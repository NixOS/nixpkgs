{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "pyqrcode";
  version = "1.2.1";

  src = fetchPypi {
    pname = "PyQRCode";
    inherit version;
    hash = "sha256-/b92NHM+VrcuJ/m85G5FULdaOixCBBQDXK6dnSayNNU=";
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
