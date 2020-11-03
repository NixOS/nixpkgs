{ buildPythonPackage, fetchPypi
, cookies, mock, requests, six }:

buildPythonPackage rec {
  pname = "responses";
  version = "0.10.16";

  src = fetchPypi {
    inherit pname version;
    sha256 = "fa125311607ab3e57d8fcc4da20587f041b4485bdfb06dd6bdf19d8b66f870c1";
  };

  requiredPythonModules = [ cookies mock requests six ];

  doCheck = false;
}
