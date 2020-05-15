{ buildPythonPackage, fetchPypi
, cookies, mock, requests, six }:

buildPythonPackage rec {
  pname = "responses";
  version = "0.10.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8ce8cb4e7e1ad89336f8865af152e0563d2e7f0e0b86d2cf75f015f819409243";
  };

  propagatedBuildInputs = [ cookies mock requests six ];

  doCheck = false;
}
