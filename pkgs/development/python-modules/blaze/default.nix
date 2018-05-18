{ lib
, buildPythonPackage
, fetchFromGitHub
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

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = version;
    sha256 = "0w916k125058p40cf7i090f75pgv3cqdb8vwjzqhb9r482fa6717";
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