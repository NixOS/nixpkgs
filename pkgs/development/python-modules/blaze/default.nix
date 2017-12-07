{ lib
, buildPythonPackage
, fetchurl
, pytest
, contextlib2
, cytoolz
, dask
, datashape
, flask
, flask-cors
, h5py
, multipledispatch
, numba
, numpy
, odo
, pandas
, psutil
, pymongo
, pyyaml
, requests
, sqlalchemy
, tables
, toolz
}:

buildPythonPackage rec {
  pname = "blaze";
  version = "0.11.0";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://github.com/blaze/blaze/archive/${version}.tar.gz";
    sha256 = "07zrrxkmdqk84xvdmp29859zcfzlpx5pz6g62l28nqp6n6a7yq9a";
  };

  checkInputs = [ pytest ];
  propagatedBuildInputs = [
    contextlib2
    cytoolz
    dask
    datashape
    flask
    flask-cors
    h5py
    multipledispatch
    numba
    numpy
    odo
    pandas
    psutil
    pymongo
    pyyaml
    requests
    sqlalchemy
    tables
    toolz
  ];

  # Failing test
  # ERROR collecting blaze/tests/test_interactive.py
  # E   networkx.exception.NetworkXNoPath: node <class 'list'> not
  # reachable from <class 'dask.array.core.Array'>
  doCheck = false;

  checkPhase = ''
    py.test blaze/tests
  '';

  meta = {
    homepage = https://github.com/ContinuumIO/blaze;
    description = "Allows Python users a familiar interface to query data living in other data storage systems";
    license = lib.licenses.bsdOriginal;
    maintainers = with lib.maintainers; [ fridh ];
  };
}