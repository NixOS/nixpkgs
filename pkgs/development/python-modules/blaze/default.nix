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
  version = "0.11.3";

  src = fetchurl {
    url = "https://github.com/blaze/blaze/archive/${version}.tar.gz";
    sha256 = "075gqc9d7g284z4nfwv5zbq99ln22w25l4lcndjg3v10kmsjadww";
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

  checkPhase = ''
    rm pytest.ini # Not interested in coverage
    py.test blaze/tests
  '';

  meta = {
    homepage = https://github.com/ContinuumIO/blaze;
    description = "Allows Python users a familiar interface to query data living in other data storage systems";
    license = lib.licenses.bsdOriginal;
    maintainers = with lib.maintainers; [ fridh ];
  };
}