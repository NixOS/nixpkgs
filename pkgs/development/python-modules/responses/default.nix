{ buildPythonPackage, fetchPypi
, cookies, mock, requests, six }:

buildPythonPackage rec {
  pname = "responses";
  version = "0.10.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "16ad4a7a914f20792111157adf09c63a8dc37699c57d1ad20dbc281a4f5743fb";
  };

  propagatedBuildInputs = [ cookies mock requests six ];

  doCheck = false;
}
