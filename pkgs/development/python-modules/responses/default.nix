{ buildPythonPackage, fetchPypi
, cookies, mock, requests, six }:

buildPythonPackage rec {
  pname = "responses";
  version = "0.12.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2e5764325c6b624e42b428688f2111fea166af46623cb0127c05f6afb14d3457";
  };

  propagatedBuildInputs = [ cookies mock requests six ];

  doCheck = false;
}
