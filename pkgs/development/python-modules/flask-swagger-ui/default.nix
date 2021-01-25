{ lib, buildPythonPackage, fetchPypi, flask }:

buildPythonPackage rec {
  pname = "flask-swagger-ui";
  version = "3.36.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f329752a65b2940ada8eeb57bce613f7c0a12856a9c31063bb9e33798554c9ed";
  };

  doCheck = false;  # there are no tests

  propagatedBuildInputs = [
    flask
  ];

  meta = with lib; {
    homepage = "https://github.com/sveint/flask-swagger-ui";
    license = licenses.mit;
    description = "Swagger UI blueprint for Flask";
    maintainers = with maintainers; [ vanschelven ];
  };
}
