{ lib, buildPythonPackage, fetchPypi, isPy27, urllib3 }:

buildPythonPackage rec {
  pname = "pyotp";
  version = "2.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "01eceab573181188fe038d001e42777884a7f5367203080ef5bda0e30fe82d28";
  };

  doCheck = (!isPy27); # Tests import urllib3 in a way python27 does not support

  checkInputs = [ urllib3 ];

  meta = with lib; {
    description = "Python One Time Password Library";
    homepage = "https://github.com/pyotp/pyotp";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
