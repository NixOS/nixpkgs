{ lib, buildPythonPackage, fetchPypi, flask }:

buildPythonPackage rec {
  pname = "flask-swagger-ui";
  version = "4.11.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-o3AZmngNZ4sy448b4Q1Nge+g7mPp/i+3Zv8aS2w32sg=";
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
