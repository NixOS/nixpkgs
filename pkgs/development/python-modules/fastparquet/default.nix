{ lib, buildPythonPackage, fetchFromGitHub, numba, numpy, pandas, pytestrunner
, thrift, pytestCheckHook, python-snappy, lz4, zstandard, zstd }:

buildPythonPackage rec {
  pname = "fastparquet";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "dask";
    repo = pname;
    rev = version;
    sha256 = "17i091kky34m2xivk29fqsyxxxa7v4352n79w01n7ni93za6wana";
  };

  nativeBuildInputs = [ pytestrunner ];
  propagatedBuildInputs = [ numba numpy pandas thrift ];
  checkInputs = [ pytestCheckHook python-snappy lz4 zstandard zstd ];

  # E   ModuleNotFoundError: No module named 'fastparquet.speedups'
  doCheck = false;
  pythonImportsCheck = [ "fastparquet" ];

  meta = with lib; {
    description = "A python implementation of the parquet format";
    homepage = "https://github.com/dask/fastparquet";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ veprbl ];
  };
}
