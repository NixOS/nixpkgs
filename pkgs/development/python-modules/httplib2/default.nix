{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "httplib2";
  version = "0.12.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f61fb838a94ce3b349aa32c92fd8430f7e3511afdb18bf9640d647e30c90a6d6";
  };

  # Needs setting up
  doCheck = false;

  meta = with lib; {
    homepage = http://code.google.com/p/httplib2;
    description = "A comprehensive HTTP client library";
    license = licenses.mit;
    maintainers = with maintainers; [ garbas ];
  };
}
