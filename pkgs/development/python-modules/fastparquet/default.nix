{ lib, buildPythonPackage, fetchFromGitHub, numba, numpy, pandas, pytestrunner,
thrift, pytest, python-snappy, lz4, zstd }:

buildPythonPackage rec {
  pname = "fastparquet";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "dask";
    repo = pname;
    rev = version;
    sha256 = "0y89gmcfylxqm8rs1fbirwjzmhcvlfx8fhvkm3ssbj1ivfd5mdlr";
  };

  postPatch = ''
    # FIXME: package zstandard
    # removing the test dependency for now
    substituteInPlace setup.py --replace "'zstandard'," ""

    # workaround for https://github.com/dask/fastparquet/issues/517
    rm fastparquet/test/test_partition_filters_specialstrings.py
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
