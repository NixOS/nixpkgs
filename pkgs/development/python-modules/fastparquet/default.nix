{ lib, buildPythonPackage, fetchPypi, numba, numpy, pandas, pytestrunner,
thrift, pytest, python-snappy, lz4 }:

buildPythonPackage rec {
  pname = "fastparquet";
  version = "0.3.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d81dcec444f4c4829234b9baac57c7125b8fbe9119c2eca2dee922650db49205";
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
