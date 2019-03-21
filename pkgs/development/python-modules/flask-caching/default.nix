{ lib, buildPythonPackage, fetchPypi, flask, pytest, pytestcov }:

buildPythonPackage rec {
  pname = "Flask-Caching";
  version = "1.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e34f24631ba240e09fe6241e1bf652863e0cff06a1a94598e23be526bc2e4985";
  };

  propagatedBuildInputs = [ flask ];

  checkInputs = [ pytest pytestcov ];

  checkPhase = ''
    py.test
  '';

  # https://github.com/sh4nks/flask-caching/pull/74
  doCheck = false;

  meta = with lib; {
    description = "Adds caching support to your Flask application";
    homepage = https://github.com/sh4nks/flask-caching;
    license = licenses.bsd3;
  };
}
