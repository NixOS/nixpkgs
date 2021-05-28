{ stdenv, buildPythonPackage, fetchPypi, pytest, flask, werkzeug, setuptools_scm }:

buildPythonPackage rec {
  pname = "pytest-flask";
  version = "1.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4d5678a045c07317618d80223ea124e21e8acc89dae109542dd1fdf6783d96c2";
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
