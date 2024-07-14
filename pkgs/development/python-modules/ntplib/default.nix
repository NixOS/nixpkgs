{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "ntplib";
  version = "0.4.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-iZ2PtfjCVVITrqle/KApNMc0Pfas6ddiilF2sXaQYmc=";
  };

  # Require networking
  doCheck = false;

  meta = with lib; {
    description = "Python NTP library";
    homepage = "http://code.google.com/p/ntplib/";
    license = licenses.mit;
  };
}
