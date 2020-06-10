{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "httplib2";
  version = "0.17.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1e9340ecf0187a621bdcfb407c32e04e8e09fc6ab28b050efa38f20eae0e975f";
  };

  # Needs setting up
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/httplib2/httplib2";
    description = "A comprehensive HTTP client library";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
