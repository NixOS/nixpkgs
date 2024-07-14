{
  lib,
  buildPythonPackage,
  fetchPypi,
  flask,
  visitor,
  dominate,
}:

buildPythonPackage rec {
  pname = "flask-bootstrap";
  version = "3.3.7.1";

  src = fetchPypi {
    pname = "Flask-Bootstrap";
    inherit version;
    hash = "sha256-ywjtlAGD9jQ6ZORl6Ds6PxPFPhuqu41ytdpFRe8SOsg=";
  };

  propagatedBuildInputs = [
    flask
    visitor
    dominate
  ];

  meta = with lib; {
    homepage = "https://github.com/mbr/flask-bootstrap";
    description = "Ready-to-use Twitter-bootstrap for use in Flask";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
