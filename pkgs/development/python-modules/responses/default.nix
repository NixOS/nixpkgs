{ buildPythonPackage, fetchPypi
, cookies, mock, requests, six }:

buildPythonPackage rec {
  pname = "responses";
  version = "0.10.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "502d9c0c8008439cfcdef7e251f507fcfdd503b56e8c0c87c3c3e3393953f790";
  };

  propagatedBuildInputs = [ cookies mock requests six ];

  doCheck = false;
}
