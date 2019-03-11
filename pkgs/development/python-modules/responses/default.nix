{ buildPythonPackage, fetchPypi
, cookies, mock, requests, six }:

buildPythonPackage rec {
  pname = "responses";
  version = "0.10.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c85882d2dc608ce6b5713a4e1534120f4a0dc6ec79d1366570d2b0c909a50c87";
  };

  propagatedBuildInputs = [ cookies mock requests six ];

  doCheck = false;
}
