{ stdenv, buildPythonPackage, fetchPypi
, pytest, pytest_xdist, virtualenv, process-tests, coverage }:

buildPythonPackage rec {
  pname = "pytest-cov";
  version = "2.6.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0ab664b25c6aa9716cbf203b17ddb301932383046082c081b9848a0edf5add33";
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
