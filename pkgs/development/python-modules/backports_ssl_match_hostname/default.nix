{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "backports.ssl_match_hostname";
  version = "3.5.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1wndipik52cyqy0677zdgp90i435pmvwd89cz98lm7ri0y3xjajh";
  };

  meta = with lib; {
    description = "The Secure Sockets layer is only actually *secure*";
    homepage = https://bitbucket.org/brandon/backports.ssl_match_hostname;
    license = licenses.psfl;
  };
}
