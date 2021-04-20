{ buildPythonPackage, fetchFromPyPI
, requests, six, dateutil }:

buildPythonPackage rec {
  pname = "hypchat";
  version = "0.21";

  src = fetchFromPyPI {
    inherit pname version;
    sha256 = "1sd8f3gihagaqd848dqy6xw457fa4f9bla1bfyni7fq3h76sjdzg";
  };

  propagatedBuildInputs = [ requests six dateutil ];
}
