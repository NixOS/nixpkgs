{ stdenv, buildPythonPackage, fetchPypi, flask }:

buildPythonPackage rec {
  pname = "flask-swagger-ui";
  version = "3.25.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "42d098997e06b04f992609c4945cc990738b269c153d8388fc59a91a5dfcee9e";
  };

  doCheck = false;  # there are no tests

  propagatedBuildInputs = [
    flask
  ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/sveint/flask-swagger-ui";
    license = licenses.mit;
    description = "Swagger UI blueprint for Flask";
    maintainers = with maintainers; [ vanschelven ];
  };
}
