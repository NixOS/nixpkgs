{ lib, buildPythonPackage, fetchFromGitHub, numba, numpy, pandas, pytestrunner,
thrift, pytest, python-snappy, lz4 }:

buildPythonPackage rec {
  pname = "fastparquet";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "dask";
    repo = pname;
    rev = version;
    sha256 = "142kmyddaq6mvmca23abwns1csn8f3lk9c8mbxwxrg4wa1dh0lb4";
  };

  postPatch = ''
    # FIXME: package zstandard
    # removing the test dependency for now
    substituteInPlace setup.py --replace "'zstandard'," ""
  '';

  nativeBuildInputs = [ pytestrunner ];
  propagatedBuildInputs = [ numba numpy pandas thrift ];
  checkInputs = [ pytest python-snappy lz4 ];

  meta = with lib; {
    description = "A python implementation of the parquet format";
    homepage = https://github.com/dask/fastparquet;
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ veprbl ];
  };
}
