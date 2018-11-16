{ stdenv, buildPythonPackage, fetchPypi
, pytest, pytest_xdist, virtualenv, process-tests, coverage }:

buildPythonPackage rec {
  pname = "pytest-cov";
  version = "2.5.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "03aa752cf11db41d281ea1d807d954c4eda35cfa1b21d6971966cc041bbf6e2d";
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
