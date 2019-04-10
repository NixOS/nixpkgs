{ lib
, buildPythonPackage
, fetchPypi
, setuptools_scm
, pytest
}:

buildPythonPackage rec {
  pname = "pytest-forked";
  version = "1.0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d352aaced2ebd54d42a65825722cb433004b4446ab5d2044851d9cc7a00c9e38";
  };

  buildInputs = [ pytest setuptools_scm ];

  # Do not function
  doCheck = false;

  checkPhase = ''
    py.test testing
  '';

  meta = {
    description = "Run tests in isolated forked subprocesses";
    homepage = https://github.com/pytest-dev/pytest-forked;
    license = lib.licenses.mit;
  };

}