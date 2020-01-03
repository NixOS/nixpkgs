{ buildPythonPackage, fetchPypi
, cookies, mock, requests, six }:

buildPythonPackage rec {
  pname = "responses";
  version = "0.10.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "46d4e546a19fc6106bc7e804edd4551ef04690405e41e7e750ebc295d042623b";
  };

  propagatedBuildInputs = [ cookies mock requests six ];

  doCheck = false;
}
