{ stdenv, fetchPypi, buildPythonPackage, isPy3k, execnet, pytest, setuptools_scm, pytest-forked }:

buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "pytest-xdist";
  version = "1.20.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7924d45c2430191fe3679a58116c74ceea13307d7822c169d65fd59a24b3a4fe";
  };

  buildInputs = [ pytest setuptools_scm pytest-forked];
  propagatedBuildInputs = [ execnet ];

  postPatch = ''
    rm testing/acceptance_test.py testing/test_remote.py testing/test_slavemanage.py
  '';

  checkPhase = ''
    py.test testing
  '';

  # Only test on 3.x
  # INTERNALERROR> AttributeError: 'NoneType' object has no attribute 'getconsumer'
  doCheck = isPy3k;

  meta = with stdenv.lib; {
    description = "py.test xdist plugin for distributed testing and loop-on-failing modes";
    homepage = https://github.com/pytest-dev/pytest-xdist;
    license = licenses.mit;
  };
}
