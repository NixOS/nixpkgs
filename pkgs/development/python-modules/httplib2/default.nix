{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "httplib2";
  version = "0.12.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4ba6b8fd77d0038769bf3c33c9a96a6f752bc4cdf739701fdcaf210121f399d4";
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
