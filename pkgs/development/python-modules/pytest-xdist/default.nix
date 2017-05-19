{ stdenv, fetchPypi, buildPythonPackage, isPy3k, execnet, pytest, setuptools_scm }:

buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "pytest-xdist";
  version = "1.16.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "42e5a1e5da9d7cff3e74b07f8692598382f95624f234ff7e00a3b1237e0feba2";
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
