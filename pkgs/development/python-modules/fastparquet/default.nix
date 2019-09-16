{ lib, buildPythonPackage, fetchPypi, fetchpatch, numba, numpy, pandas,
pytestrunner, thrift, pytest, python-snappy, lz4 }:

buildPythonPackage rec {
  pname = "fastparquet";
  version = "0.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "183wdmhnhnlsd7908n3d2g4qnb49fcipqfshghwpbdwdzjpa0day";
  };

  # Fixes for recent pandas version
  # See https://github.com/dask/fastparquet/pull/396
  patches = fetchpatch {
    url = https://github.com/dask/fastparquet/commit/31fb3115598d1ab62a5c8bf7923a27c16f861529.patch;
    sha256 = "0r1ig4rydmy4j85dgb52qbsx6knxdwn4dn9h032fg3p6xqq0zlpm";
  };

  postPatch = ''
    # FIXME: package zstandard
    # removing the test dependency for now
    substituteInPlace setup.py --replace "'zstandard'," ""
  '';

  nativeBuildInputs = [ pytestrunner ];
  propagatedBuildInputs = [ numba numpy pandas thrift ];
  checkInputs = [ pytest python-snappy lz4 ];

  # test_data/ missing in PyPI tarball
  doCheck = false;

  meta = with lib; {
    description = "A python implementation of the parquet format";
    homepage = https://github.com/dask/fastparquet;
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ veprbl ];
  };
}
