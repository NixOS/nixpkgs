{ stdenv, buildPythonPackage, fetchPypi, pytest, flask, werkzeug, setuptools_scm }:

buildPythonPackage rec {
  pname = "pytest-flask";
  version = "0.15.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1ri3p3hibb1r2wcblpvs64s4jz40ci4jki4s2nf3xf7iz2wwbn6b";
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
