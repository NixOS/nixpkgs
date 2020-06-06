{ lib
, buildPythonPackage
, fetchPypi
, pytest
, pytest-repeat
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
, isPy3k
, futures
, singledispatch
, mpi4py
, bokeh
}:

buildPythonPackage rec {
  pname = "distributed";
  version = "2.18.0";

  # get full repository need conftest.py to run tests
  src = fetchPypi {
    inherit pname version;
    sha256 = "902f098fb7558f035333804a5aeba2fb26a2a715388808205a17cbb2e02e0558";
  };

  checkInputs = [ pytest pytest-repeat pytest-timeout mock joblib ];
  propagatedBuildInputs = [
      click cloudpickle dask msgpack psutil six
      sortedcontainers tblib toolz tornado zict pyyaml mpi4py bokeh
  ] ++ lib.optionals (!isPy3k) [ futures singledispatch ];

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
    homepage = "https://distributed.readthedocs.io/en/latest/";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.x86; # fails on aarch64
    maintainers = with lib.maintainers; [ teh costrouc ];
  };
}
