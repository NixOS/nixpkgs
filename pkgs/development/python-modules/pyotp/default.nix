{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "pyotp";
  version = "2.2.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "00p69nw431f0s2ilg0hnd77p1l22m06p9rq4f8zfapmavnmzw3xy";
  };

  meta = with lib; {
    description = "Python One Time Password Library";
    homepage = https://github.com/pyotp/pyotp;
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
