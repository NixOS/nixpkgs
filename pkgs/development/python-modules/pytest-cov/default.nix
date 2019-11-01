{ stdenv, buildPythonPackage, fetchPypi
, pytest, coverage }:

buildPythonPackage rec {
  pname = "pytest-cov";
  version = "2.8.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "cc6742d8bac45070217169f5f72ceee1e0e55b0221f54bcf24845972d3a47f2b";
  };

  buildInputs = [ pytest ];
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
