{ stdenv, buildPythonPackage, fetchPypi
, cookies, mock, requests, six }:

buildPythonPackage rec {
  pname = "responses";
  version = "0.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0fs7a4cf4f12mjhcjd5vfh0f3ixcy2nawzxpgsfr3ahf0rg7ppx5";
  };

  propagatedBuildInputs = [ cookies mock requests six ];

  doCheck = false;
}
