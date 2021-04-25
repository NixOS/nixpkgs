{ buildPythonPackage, fetchPypi
, cookies, mock, requests, six }:

buildPythonPackage rec {
  pname = "responses";
  version = "0.13.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "cf62ab0f4119b81d485521b2c950d8aa55a885c90126488450b7acb8ee3f77ac";
  };

  propagatedBuildInputs = [ cookies mock requests six ];

  doCheck = false;
}
