{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "pyotp";
  version = "2.2.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "dd9130dd91a0340d89a0f06f887dbd76dd07fb95a8886dc4bc401239f2eebd69";
  };

  meta = with lib; {
    description = "Python One Time Password Library";
    homepage = https://github.com/pyotp/pyotp;
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
