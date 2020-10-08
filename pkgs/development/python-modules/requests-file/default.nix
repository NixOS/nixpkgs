{ lib, fetchPypi, buildPythonPackage, pytestCheckHook, requests, six }:

buildPythonPackage rec {
  pname   = "requests-file";
  version = "1.5.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "07d74208d3389d01c38ab89ef403af0cfec63957d53a0081d8eca738d0247d8e";
  };

  propagatedBuildInputs = [ requests six ];

  checkInputs = [ pytestCheckHook ];

  meta = {
    homepage = "https://github.com/dashea/requests-file";
    description = "Transport adapter for fetching file:// URLs with the requests python library";
    license = lib.licenses.asl20;
  };

}
