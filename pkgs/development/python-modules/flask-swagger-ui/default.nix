{ lib, buildPythonPackage, fetchFromGitHub, flask }:

buildPythonPackage rec {
  pname = "flask-swagger-ui";
  version = "3.36.0";

  src = fetchFromGitHub {
     owner = "sveint";
     repo = "flask-swagger-ui";
     rev = "3.36.0";
     sha256 = "0mg3skydq15gv5gv3i2f6131fijdvq9607is01fx26dczs57nii2";
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
