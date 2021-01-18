{ lib, stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "ntplib";
  version = "0.3.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9fc99f71b14641b31698e4ced3d5f974eec225bfbae089ebe44b5808ba890f71";
  };

  # Require networking
  doCheck = false;

  meta = with lib; {
    description = "Python NTP library";
    homepage = "http://code.google.com/p/ntplib/";
    license = licenses.mit;
  };

}
