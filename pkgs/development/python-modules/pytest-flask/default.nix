{ stdenv, buildPythonPackage, fetchPypi, pytest, flask, werkzeug, setuptools_scm }:

buildPythonPackage rec {
  pname = "pytest-flask";
  version = "0.15.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0jdzrib94vwfpl8524h34aqzqndh3h4xn706v32xh412c8dphx6q";
  };

  doCheck = false;

  buildInputs = [
     pytest
  ];

  propagatedBuildInputs = [
    flask
    werkzeug
  ];

  nativeBuildInputs = [ setuptools_scm ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/pytest-dev/pytest-flask/";
    license = licenses.mit;
    description = "A set of py.test fixtures to test Flask applications";
    maintainers = with maintainers; [ vanschelven ];
  };
}
