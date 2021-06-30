{ buildPythonPackage, fetchPypi
, cookies, mock, requests, six }:

buildPythonPackage rec {
  pname = "responses";
  version = "0.13.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "18a5b88eb24143adbf2b4100f328a2f5bfa72fbdacf12d97d41f07c26c45553d";
  };

  propagatedBuildInputs = [ cookies mock requests six ];

  doCheck = false;
}
