{ lib
, buildPythonPackage
, fetchPypi
, fetchpatch
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
, mpi4py
, bokeh
, pythonOlder
}:

buildPythonPackage rec {
  pname = "distributed";
  version = "2021.3.0";
  disabled = pythonOlder "3.6";

  # get full repository need conftest.py to run tests
  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-Qn/n4Ee7rXQTxl1X5W+k1rHPkh/SBqPSyquUv5FTw9s=";
  };

  patches = [
    (fetchpatch {
      name = "CVE-2021-42343.patch";
      url = "https://github.com/dask/distributed/commit/afce4be8e05fb180e50a9d9e38465f1a82295e1b.patch";
      sha256 = "1rww36948lrffbg0r94lav0ki1v5vvqi7jfdflhlnb5dz0rnw686";
      # conflicts and we don't run the tests at the moment anyway
      excludes = [ "distributed/deploy/tests/*" ];
    })
  ];

  propagatedBuildInputs = [
      click cloudpickle dask msgpack psutil six
      sortedcontainers tblib toolz tornado zict pyyaml mpi4py bokeh
  ];

  # when tested random tests would fail and not repeatably
  doCheck = false;
  pythonImportsCheck = [ "distributed" ];

  meta = with lib; {
    description = "Distributed computation in Python.";
    homepage = "https://distributed.readthedocs.io/en/latest/";
    license = licenses.bsd3;
    platforms = platforms.x86; # fails on aarch64
    maintainers = with maintainers; [ teh costrouc ];
  };
}
