{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "httplib2";
  version = "0.12.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a18121c7c72a56689efbf1aef990139ad940fee1e64c6f2458831736cd593600";
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
