{ buildPythonPackage, fetchPypi
, cookies, mock, requests, six }:

buildPythonPackage rec {
  pname = "responses";
  version = "0.10.15";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7bb697a5fedeb41d81e8b87f152d453d5cab42dcd1691b6a7d6097e94d33f373";
  };

  propagatedBuildInputs = [ cookies mock requests six ];

  doCheck = false;
}
