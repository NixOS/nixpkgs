{ stdenv, fetchPypi, buildPythonPackage, isPy3k, execnet, pytest, setuptools_scm }:

buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "pytest-xdist";
  version = "1.18.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "10468377901b80255cf192c4603a94ffe8b1f071f5c912868da5f5cb91170dae";
  };

  buildInputs = [ pytest setuptools_scm ];
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
