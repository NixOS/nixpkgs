{ lib, fetchPypi, buildPythonPackage, flask }:

buildPythonPackage rec {
  pname = "flask-sslify";
  version = "0.1.5";

  src = fetchPypi {
    pname = "Flask-SSLify";
    inherit version;
    sha256 = "0gjl1m828z5dm3c5dpc2qjgi4llf84cp72mafr0ib5fd14y1sgnk";
  };

  propagatedBuildInputs = [ flask ];

  doCheck = false;
  pythonImportsCheck = [ "flask_sslify" ];

  meta = with lib; {
    description = "A Flask extension that redirects all incoming requests to HTTPS";
    homepage = "https://github.com/kennethreitz42/flask-sslify";
    license = licenses.bsd2;
    maintainers = with maintainers; [ zhaofengli ];
  };
}
