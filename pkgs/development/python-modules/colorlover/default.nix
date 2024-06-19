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
    sha256 = "b8fb7246ab46e1f5e6715649453c1762e245a515de5ff2d2b4aab7a6e67fa4e2";
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
