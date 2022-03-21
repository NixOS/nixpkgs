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
  version = "2022.2.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  # get full repository need conftest.py to run tests
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Gi9u7JczpnAEg53E7N5tXBfAeWZaLBVzRU3SpbU3bZU=";
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

  postPatch = ''
    substituteInPlace requirements.txt \
      --replace "dask == 2022.02.0" "dask"
  '';

  # when tested random tests would fail and not repeatably
  doCheck = false;

  pythonImportsCheck = [
    "distributed"
  ];

  meta = with lib; {
    description = "Distributed computation in Python";
    homepage = "https://distributed.readthedocs.io/";
    license = licenses.bsd3;
    platforms = platforms.x86; # fails on aarch64
    maintainers = with maintainers; [ teh costrouc ];
  };
}
