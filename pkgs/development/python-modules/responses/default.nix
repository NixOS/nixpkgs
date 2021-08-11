{ buildPythonPackage, fetchPypi
, cookies, mock, requests, six }:

buildPythonPackage rec {
  pname = "responses";
  version = "0.13.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-lHZ3XYVtPCSuZgu+vin7bXidStFqzXI++/tu4gmQuJk=";
  };

  propagatedBuildInputs = [ cookies mock requests six ];

  doCheck = false;
}
