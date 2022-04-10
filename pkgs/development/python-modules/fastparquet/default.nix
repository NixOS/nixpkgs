{ lib
, buildPythonPackage
, fetchFromGitHub
, python
, numba
, numpy
, pandas
, cramjam
, fsspec
, thrift
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "fastparquet";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "dask";
    repo = pname;
    rev = version;
    sha256 = "05qb4nz87p9vnrdsyl25hdp5sj35lki64gjza5dahc89fwfdnsmd";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "'pytest-runner'," "" \
      --replace "oldest-supported-numpy" "numpy"
  '';

  propagatedBuildInputs = [ cramjam fsspec numba numpy pandas thrift ];
  checkInputs = [ pytestCheckHook ];

  # Workaround https://github.com/NixOS/nixpkgs/issues/123561
  preCheck = ''
    mv fastparquet/test .
    rm -r fastparquet
    fastparquet_test="$out"/${python.sitePackages}/fastparquet/test
    ln -s `pwd`/test "$fastparquet_test"
  '';

  postCheck = ''
    rm "$fastparquet_test"
  '';

  pythonImportsCheck = [ "fastparquet" ];

  meta = with lib; {
    description = "A python implementation of the parquet format";
    homepage = "https://github.com/dask/fastparquet";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ veprbl ];
  };
}
