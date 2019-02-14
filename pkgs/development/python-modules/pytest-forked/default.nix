{ lib
, buildPythonPackage
, fetchPypi
, setuptools_scm
, pytest
}:

buildPythonPackage rec {
  pname = "pytest-forked";
  version = "1.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "260d03fbd38d5ce41a657759e8d19bc7c8cfa6d0dcfa36c0bc9742d33bc30742";
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