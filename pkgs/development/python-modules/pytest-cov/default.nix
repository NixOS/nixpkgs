{ lib, buildPythonPackage, fetchPypi
, pytest, coverage }:

buildPythonPackage rec {
  pname = "pytest-cov";
  version = "2.11.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "359952d9d39b9f822d9d29324483e7ba04a3a17dd7d05aa6beb7ea01e359e5f7";
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
