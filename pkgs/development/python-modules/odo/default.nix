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
  version= "unstable-2018-09-21";

  src = fetchFromGitHub {
    owner = "blaze";
    repo = pname;
    rev = "9fce6690b3666160681833540de6c55e922de5eb";
    sha256 = "0givkd5agr05wrf72fbghdaav6gplx7c069ngs1ip385v72ifsl9";
  };

  checkInputs = [
    pytest
    dask
  ];

  propagatedBuildInputs = [
    datashape
    numpy
    pandas
    toolz
    multipledispatch
    networkx
  ];

  postConfigure = ''
    substituteInPlace setup.py \
      --replace "versioneer.get_version()" "'0.5.1'"
  '';

  # disable 6/315 tests
  checkPhase = ''
    pytest odo -k "not test_insert_to_ooc \
               and not test_datetime_index \
               and not test_different_encoding \
               and not test_numpy_asserts_type_after_dataframe"
  '';

  meta = with lib; {
    homepage = https://github.com/ContinuumIO/odo;
    description = "Data migration utilities";
    license = licenses.bsdOriginal;
    maintainers = with maintainers; [ fridh costrouc ];
    broken = true; # no longer compatible with dask>=2.0
  };
}
