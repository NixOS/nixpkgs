{ lib
, buildPythonPackage
, fetchPypi
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
  version = "2021.6.1";
  disabled = pythonOlder "3.6";

  # get full repository need conftest.py to run tests
  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-Z79h/WAio5diX2myChx8HPAWe2RB4Ajw7Ybch4XUYFc=";
  };

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
