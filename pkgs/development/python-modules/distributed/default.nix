{ lib
, buildPythonPackage
, fetchPypi
, click
, cloudpickle
, dask
, msgpack
, psutil
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
  version = "2021.11.2";
  disabled = pythonOlder "3.6";

  # get full repository need conftest.py to run tests
  src = fetchPypi {
    inherit pname version;
    sha256 = "f86a01a2e1e678865d2e42300c47552b5012cd81a2d354e47827a1fd074cc302";
  };

  propagatedBuildInputs = [
    bokeh
    click
    cloudpickle
    dask
    mpi4py
    msgpack
    psutil
    pyyaml
    sortedcontainers
    tblib
    toolz
    tornado
    zict
  ];

  # when tested random tests would fail and not repeatably
  doCheck = false;

  pythonImportsCheck = [ "distributed" ];

  meta = with lib; {
    description = "Distributed computation in Python";
    homepage = "https://distributed.readthedocs.io/";
    license = licenses.bsd3;
    platforms = platforms.x86; # fails on aarch64
    maintainers = with maintainers; [ teh costrouc ];
  };
}
