{ lib
, buildPythonPackage
, fetchPypi
, pytest
, pytest-repeat
, pytest-faulthandler
, pytest-timeout
, mock
, joblib
, click
, cloudpickle
, dask
, msgpack
, psutil
, six
, sortedcontainers
, tblib
, toolz
, tornado
, zict
, pyyaml
, pythonOlder
, futures
, singledispatch
}:

buildPythonPackage rec {
  pname = "distributed";
  version = "1.23.3";

  # get full repository need conftest.py to run tests
  src = fetchPypi {
    inherit pname version;
    sha256 = "2d48a4de280fd7243ca76f9b12db5fe2486fc89dcdb510c77fa51f51733a04cc";
  };

  checkInputs = [ pytest pytest-repeat pytest-faulthandler pytest-timeout mock joblib ];
  propagatedBuildInputs = [
      click cloudpickle dask msgpack psutil six
      sortedcontainers tblib toolz tornado zict pyyaml
  ] ++ lib.optional (pythonOlder "3.2") [ futures ]
    ++ lib.optional (pythonOlder "3.4") [ singledispatch ];

  # tests take about 10-15 minutes
  # ignore 5 cli tests out of 1000 total tests that fail due to subprocesses
  # these tests are not critical to the library (only the cli)
  checkPhase = ''
    py.test distributed -m "not avoid-travis" -r s --timeout-method=thread --timeout=0 --durations=20 --ignore="distributed/cli/tests"
  '';

  # when tested random tests would fail and not repeatably
  doCheck = false;

  meta = {
    description = "Distributed computation in Python.";
    homepage = http://distributed.readthedocs.io/en/latest/;
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ teh costrouc ];
  };
}
