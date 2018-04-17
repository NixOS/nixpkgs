{ lib
, buildPythonPackage
, fetchFromGitHub
, pytest
, datashape
, numpy
, pandas
, toolz
, multipledispatch
, networkx
, dask
}:

buildPythonPackage rec {
  pname = "odo";
  version= "0.5.1";


  src = fetchFromGitHub {
    owner = "blaze";
    repo = pname;
    rev = version;
    sha256 = "142f4jvaqjn0dq6rvlk7d7mzcmc255a9z4nxc1b3a862hp4gvijs";
  };

  checkInputs = [ pytest dask ];
  propagatedBuildInputs = [ datashape numpy pandas toolz multipledispatch networkx ];

  # Disable failing tests
  # https://github.com/blaze/odo/issues/609
  checkPhase = ''
    py.test -k "not test_numpy_asserts_type_after_dataframe" odo/tests
  '';

  meta = {
    homepage = https://github.com/ContinuumIO/odo;
    description = "Data migration utilities";
    license = lib.licenses.bsdOriginal;
    maintainers = with lib.maintainers; [ fridh ];
    # incomaptible with Networkx 2
    # see https://github.com/blaze/odo/pull/601
    broken = true;
  };
}
