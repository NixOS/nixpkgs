{ buildPythonPackage, fetchPypi
, cookies, mock, requests, six }:

buildPythonPackage rec {
  pname = "responses";
  version = "0.10.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "682fafb124e799eeee67ec15c9678d955a88affda5613b09788ef80c03987cf0";
  };

  propagatedBuildInputs = [ cookies mock requests six ];

  doCheck = false;
}
