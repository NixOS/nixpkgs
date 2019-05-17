{ stdenv, buildPythonPackage, fetchPypi, flask }:

buildPythonPackage rec {
  pname = "flask-swagger-ui";
  version = "3.20.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3282c770764c8053360f33b2fc120e1d169ecca2138537d0e6e1135b1f9d4ff2";
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
