{ lib, buildPythonPackage, isPy3k, fetchPypi, numba, numpy, pandas,
pytestrunner, thrift }:

buildPythonPackage rec {
  pname = "fastparquet";
  version = "0.2.1";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "183wdmhnhnlsd7908n3d2g4qnb49fcipqfshghwpbdwdzjpa0day";
  };

  buildInputs = [ pytestrunner ];
  propagatedBuildInputs = [ numba numpy pandas thrift ];

  # Needs python-snappy and some patching to prevent tests from trying to
  # download python packages
  doCheck = false;

  meta = with lib; {
    description = "A python implementation of the parquet format";
    homepage = https://github.com/dask/fastparquet;
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ veprbl ];
  };
}
