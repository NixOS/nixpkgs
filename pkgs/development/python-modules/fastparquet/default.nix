{ lib, buildPythonPackage, fetchFromGitHub, numba, numpy, pandas, pytestrunner,
thrift, pytest, python-snappy, lz4, zstd }:

buildPythonPackage rec {
  pname = "fastparquet";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "dask";
    repo = pname;
    rev = version;
    sha256 = "17i091kky34m2xivk29fqsyxxxa7v4352n79w01n7ni93za6wana";
  };

  postPatch = ''
    # FIXME: package zstandard
    # removing the test dependency for now
    substituteInPlace setup.py --replace "'zstandard'," ""
  '';

  nativeBuildInputs = [ pytestrunner ];
  propagatedBuildInputs = [ numba numpy pandas thrift ];
  checkInputs = [ pytest python-snappy lz4 zstd ];

  meta = with lib; {
    description = "A python implementation of the parquet format";
    homepage = "https://github.com/dask/fastparquet";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ veprbl ];
  };
}
