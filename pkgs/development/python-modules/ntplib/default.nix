{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "ntplib";
  version = "0.4.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "899d8fb5f8c2555213aea95efca02934c7343df6ace9d7628a5176b176906267";
  };

  # Require networking
  doCheck = false;

  meta = with lib; {
    description = "Python NTP library";
    homepage = "http://code.google.com/p/ntplib/";
    license = licenses.mit;
  };

}
