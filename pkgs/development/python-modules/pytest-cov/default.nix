{ lib, stdenv, buildPythonPackage, fetchPypi
, pytest, coverage }:

buildPythonPackage rec {
  pname = "pytest-cov";
  version = "2.10.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "47bd0ce14056fdd79f93e1713f88fad7bdcc583dcd7783da86ef2f085a0bb88e";
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

  meta = with lib; {
    description = "Plugin for coverage reporting with support for both centralised and distributed testing, including subprocesses and multiprocessing";
    homepage = "https://github.com/pytest-dev/pytest-cov";
    license = licenses.mit;
  };
}
