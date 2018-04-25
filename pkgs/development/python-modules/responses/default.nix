{ stdenv, buildPythonPackage, fetchPypi
, cookies, mock, requests, six }:

buildPythonPackage rec {
  pname = "responses";
  version = "0.9.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c6082710f4abfb60793899ca5f21e7ceb25aabf321560cc0726f8b59006811c9";
  };

  propagatedBuildInputs = [ cookies mock requests six ];

  doCheck = false;
}
