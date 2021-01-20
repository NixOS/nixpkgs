{ lib, stdenv, buildPythonPackage, fetchPypi, pytest, flask, werkzeug, setuptools_scm, isPy27 }:

buildPythonPackage rec {
  pname = "pytest-flask";
  version = "1.1.0";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "9c136afd6d0fb045b0b8fd2363421b6670bfebd21d9141f79669d9051c9d2d05";
  };

  doCheck = false;

  propagatedBuildInputs = [
    pytest
    flask
    werkzeug
  ];

  nativeBuildInputs = [ setuptools_scm ];

  meta = with lib; {
    homepage = "https://github.com/pytest-dev/pytest-flask/";
    license = licenses.mit;
    description = "A set of py.test fixtures to test Flask applications";
    maintainers = with maintainers; [ vanschelven ];
  };
}
