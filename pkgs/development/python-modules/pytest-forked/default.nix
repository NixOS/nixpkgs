{ lib
, buildPythonPackage
, fetchPypi
, setuptools_scm
, pytest
}:

buildPythonPackage rec {
  pname = "pytest-forked";
  version = "1.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6aa9ac7e00ad1a539c41bec6d21011332de671e938c7637378ec9710204e37ca";
  };

  buildInputs = [ pytest setuptools_scm ];

  # Do not function
  doCheck = false;

  checkPhase = ''
    py.test testing
  '';

  meta = {
    description = "Run tests in isolated forked subprocesses";
    homepage = "https://github.com/pytest-dev/pytest-forked";
    license = lib.licenses.mit;
  };

}
