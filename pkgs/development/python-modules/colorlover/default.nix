{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "colorlover";
  version = "0.3.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-uPtyRqtG4fXmcVZJRTwXYuJFpRXeX/LStKq3puZ/pOI=";
  };

  # no tests included in distributed archive
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/jackparmer/colorlover";
    description = "Color scales in Python for humans";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
