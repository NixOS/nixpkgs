{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  version = "0.3";
  format = "setuptools";
  pname = "httpauth";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0qas7876igyz978pgldp5r7n7pis8n4vf0v87gxr9l7p7if5lr3l";
  };

  doCheck = false;

  meta = with lib; {
    description = "WSGI HTTP Digest Authentication middleware";
    homepage = "https://github.com/jonashaag/httpauth";
    license = licenses.bsd2;
    maintainers = with maintainers; [ ];
  };

}
