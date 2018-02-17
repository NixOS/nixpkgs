{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "PyQRCode";
  version = "1.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1m9ln8k9v7dfbh1i81225hx5mdsh8mpf9g7r4wpbfmiyfcs7dgzx";
  };

  meta = {
    description = "A QR code generator written purely in Python with SVG, EPS, PNG and terminal output";
    home = "https://pypi.python.org/pypi/PyQRCode/";
    license = "bsd";
  };
}

