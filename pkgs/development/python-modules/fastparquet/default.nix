{ lib, buildPythonPackage, fetchFromGitHub, numba, numpy, pandas, pytestrunner,
thrift, pytest, python-snappy, lz4 }:

buildPythonPackage rec {
  pname = "fastparquet";
  version = "0.3.3";

  src = fetchFromGitHub {
    owner = "dask";
    repo = pname;
    rev = version;
    sha256 = "1vnxr4r0bia2zi9csjw342l507nic6an4hr5xb3a36ggqlbaa0g5";
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
