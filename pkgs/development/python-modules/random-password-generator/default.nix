{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "random-password-generator";
  version = "2.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0hwx6l72zl04lp4mjbm4mrhngcqwf1i8z567dc4jrp8g8b0f5a6q";
  };

  meta = with lib; {
    description = "A minimal and custom random password generator for python";
    homepage = "https://github.com/suryasr007/random-password-generator";
    license = licenses.mit;
    maintainers = with maintainers; [ suryasr007 ];
  };
}
