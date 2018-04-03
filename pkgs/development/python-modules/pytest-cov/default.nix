{ stdenv, buildPythonPackage, fetchPypi
, pytest, pytest_xdist, virtualenv, process-tests, coverage }:

buildPythonPackage rec {
  pname = "pytest-cov";
  version = "2.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "03c2qc42r4bczyw93gd7n0qi1h1jfhw7fnbhi33c3vp1hs81gm2k";
  };

  buildInputs = [ pytest pytest_xdist virtualenv process-tests ];
  propagatedBuildInputs = [ coverage ];

  # xdist related tests fail with the following error
  # OSError: [Errno 13] Permission denied: 'py/_code'
  doCheck = false;
  checkPhase = ''
    # allow to find the module helper during the test run
    export PYTHONPATH=$PYTHONPATH:$PWD/tests
    py.test tests
  '';

  meta = with stdenv.lib; {
    description = "Plugin for coverage reporting with support for both centralised and distributed testing, including subprocesses and multiprocessing";
    homepage = https://github.com/pytest-dev/pytest-cov;
    license = licenses.mit;
  };
}
