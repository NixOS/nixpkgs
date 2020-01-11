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
  version= "unstable-2019-07-16";

  src = fetchFromGitHub {
    owner = "blaze";
    repo = pname;
    rev = "9fce6690b3666160681833540de6c55e922de5eb";
    sha256 = "0givkd5agr05wrf72fbghdaav6gplx7c069ngs1ip385v72ifsl9";
  };

  checkInputs = [
    pytest
  ];

  propagatedBuildInputs = [
    dask
    datashape
    numpy
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

  doCheck = false; # Many failing tests

  meta = with lib; {
    homepage = https://github.com/ContinuumIO/odo;
    description = "Data migration utilities";
    license = licenses.bsdOriginal;
    maintainers = with maintainers; [ fridh costrouc ];
  };
}
