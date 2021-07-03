{ lib
, buildPythonPackage
, cramjam
, fetchFromGitHub
, fsspec
, numba
, numpy
, pandas
, pytest-runner
, thrift
, pytestCheckHook
, python-snappy
, lz4
, zstandard
, zstd
}:

buildPythonPackage rec {
  pname = "fastparquet";
  version = "0.6.3";

  src = fetchFromGitHub {
    owner = "dask";
    repo = pname;
    rev = version;
    sha256 = "05lfviijbd403gii4rjxznrkcqslv8akxbn11b4w0wxvllz7l8n1";
  };

  nativeBuildInputs = [
    pytest-runner
  ];

  propagatedBuildInputs = [
    cramjam
    fsspec
    lz4
    numba
    numpy
    pandas
    python-snappy
    thrift
    zstandard
    zstd
  ];

  checkInputs = [
    pytestCheckHook
  ];

  # E   ModuleNotFoundError: No module named 'fastparquet.speedups'
  doCheck = false;

  pythonImportsCheck = [ "fastparquet" ];

  meta = with lib; {
    description = "Python implementation of the parquet format";
    homepage = "https://github.com/dask/fastparquet";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ veprbl ];
  };
}
