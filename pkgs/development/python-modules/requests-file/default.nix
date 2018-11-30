{ lib, fetchPypi, buildPythonPackage, requests, six }:

buildPythonPackage rec {
  pname   = "requests-file";
  version = "1.4.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1yp2jaxg3v86pia0q512dg3hz6s9y5vzdivsgrba1kds05ial14g";
  };

  propagatedBuildInputs = [ requests six ];

  meta = {
    homepage = https://github.com/dashea/requests-file;
    description = "Transport adapter for fetching file:// URLs with the requests python library";
    license = lib.licenses.asl20;
  };

}
