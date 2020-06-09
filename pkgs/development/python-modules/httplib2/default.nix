{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "httplib2";
  version = "0.17.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "39dd15a333f67bfb70798faa9de8a6e99c819da6ad82b77f9a259a5c7b1225a2";
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
