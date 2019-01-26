{ lib
, buildPythonPackage
, fetchPypi
, setuptools_scm
, pytest
}:

buildPythonPackage rec {
  pname = "pytest-forked";
  version = "0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e4500cd0509ec4a26535f7d4112a8cc0f17d3a41c29ffd4eab479d2a55b30805";
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