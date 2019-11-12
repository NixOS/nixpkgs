{ lib
, buildPythonPackage
, fetchPypi
, setuptools_scm
, pytest
}:

buildPythonPackage rec {
  pname = "pytest-forked";
  version = "1.1.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1805699ed9c9e60cb7a8179b8d4fa2b8898098e82d229b0825d8095f0f261100";
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