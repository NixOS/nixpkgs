{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "pyotp";
  version = "2.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "18d13ikra1iq0xyfqfm72zhgwxi2qi9ps6z1a6zmqp4qrn57wlzw";
  };

  meta = with lib; {
    description = "Python One Time Password Library";
    homepage = "https://github.com/pyotp/pyotp";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
