{ lib
, buildPythonPackage
, fetchFromGitHub
, python
, numba
, numpy
, pandas
, pytest-runner
, cramjam
, fsspec
, thrift
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "fastparquet";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "dask";
    repo = pname;
    rev = version;
    hash = "sha256-08hanzRnt6WuMriNNtOd+ZHycr2XBeIRav+5sgvT7Do=";
  };

  nativeBuildInputs = [ pytest-runner ];
  propagatedBuildInputs = [ cramjam fsspec numba numpy pandas thrift ];
  checkInputs = [ pytestCheckHook ];

  # Workaround https://github.com/NixOS/nixpkgs/issues/123561
  preCheck = ''
    mv fastparquet/test .
    rm -rf fastparquet
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
