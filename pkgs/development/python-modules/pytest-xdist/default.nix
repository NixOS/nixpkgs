{ stdenv, fetchPypi, buildPythonPackage, isPy3k, execnet, pytest, setuptools_scm, pytest-forked }:

buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "pytest-xdist";
  version = "1.22.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "65228a859191f2c74ee68c127317eefe35eedd3d43fc1431f19240663b0cafcd";
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
