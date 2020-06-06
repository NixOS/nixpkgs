{ buildPythonPackage, fetchPypi
, cookies, mock, requests, six }:

buildPythonPackage rec {
  pname = "responses";
  version = "0.10.14";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1a78bc010b20a5022a2c0cb76b8ee6dc1e34d887972615ebd725ab9a166a4960";
  };

  propagatedBuildInputs = [ cookies mock requests six ];

  doCheck = false;
}
