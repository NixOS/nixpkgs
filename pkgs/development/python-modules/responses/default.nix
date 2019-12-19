{ buildPythonPackage, fetchPypi
, cookies, mock, requests, six }:

buildPythonPackage rec {
  pname = "responses";
  version = "0.10.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "caa5f7afd14666f970ea54a4125a639f6491218b45a013c6dc2544f0473ae2b8";
  };

  propagatedBuildInputs = [ cookies mock requests six ];

  doCheck = false;
}
