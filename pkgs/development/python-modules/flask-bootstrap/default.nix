{ lib, buildPythonPackage, fetchPypi, flask, visitor, dominate }:

buildPythonPackage rec {
  pname = "flask-bootstrap";
  version = "3.3.7.1";

  src = fetchPypi {
    pname = "Flask-Bootstrap";
    inherit version;
    sha256 = "1j1s2bplaifsnmr8vfxa3czca4rz78xyhrg4chx39xl306afs26b";
  };

  propagatedBuildInputs = [ flask visitor dominate ];

  meta = with lib; {
    homepage = "https://github.com/mbr/flask-bootstrap";
    description = "Ready-to-use Twitter-bootstrap for use in Flask.";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
