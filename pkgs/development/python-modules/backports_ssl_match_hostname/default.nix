{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "backports.ssl_match_hostname";
  version = "3.7.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "bb82e60f9fbf4c080eabd957c39f0641f0fc247d9a16e31e26d594d8f42b9fd2";
  };

  meta = with lib; {
    description = "The Secure Sockets layer is only actually *secure*";
    homepage = https://bitbucket.org/brandon/backports.ssl_match_hostname;
    license = licenses.psfl;
  };
}
