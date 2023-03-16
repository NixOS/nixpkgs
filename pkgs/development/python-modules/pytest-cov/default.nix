{ lib
, buildPythonPackage
, fetchPypi
, pytest
, coverage
, toml
, tomli
}:

buildPythonPackage rec {
  pname = "pytest-cov";
  version = "4.0.0";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-mWt5795kM829AIiHLbxfs+1/4VeLaM27pjTxS7jdBHA=";
  };

  buildInputs = [ pytest ];

  propagatedBuildInputs = [ coverage toml tomli ];

  # xdist related tests fail with the following error
  # OSError: [Errno 13] Permission denied: 'py/_code'
  doCheck = false;
  checkPhase = ''
    # allow to find the module helper during the test run
    export PYTHONPATH=$PYTHONPATH:$PWD/tests
    py.test tests
  '';

  pythonImportsCheck = [ "pytest_cov" ];

  meta = with lib; {
    description = "Plugin for coverage reporting with support for both centralised and distributed testing, including subprocesses and multiprocessing";
    homepage = "https://github.com/pytest-dev/pytest-cov";
    license = licenses.mit;
  };
}
