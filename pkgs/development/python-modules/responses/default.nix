{ buildPythonPackage, fetchPypi
, cookies, mock, requests, six }:

buildPythonPackage rec {
  pname = "responses";
  version = "0.10.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5b99beef28dd177da180604be2e849a16c3a40605bfda7c8d792a9924dd3d60e";
  };

  propagatedBuildInputs = [ cookies mock requests six ];

  doCheck = false;
}
