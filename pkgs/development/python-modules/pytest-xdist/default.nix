{ stdenv, fetchPypi, buildPythonPackage, isPy3k, execnet, pytest, setuptools_scm, pytest-forked }:

buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "pytest-xdist";
  version = "1.20.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "433e82f9b34986a4e4b2be38c60e82cca3ac64b7e1b38f4d8e3e118292939712";
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
