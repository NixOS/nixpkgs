{ buildPythonPackage, fetchPypi
, cookies, mock, requests, six }:

buildPythonPackage rec {
  pname = "responses";
  version = "0.12.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e80d5276011a4b79ecb62c5f82ba07aa23fb31ecbc95ee7cad6de250a3c97444";
  };

  propagatedBuildInputs = [ cookies mock requests six ];

  doCheck = false;
}
