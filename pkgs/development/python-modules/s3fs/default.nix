{ stdenv, buildPythonPackage, fetchPypi, docutils, boto3 }:

buildPythonPackage rec {
  pname = "s3fs";
  version = "0.1.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f19b2e81cfcf6f2849fa8195c366c6e81d2378400bab0611f461c4e55d4f6bed";
  };

  buildInputs = [ docutils ];
  propagatedBuildInputs = [ boto3 ];

  # Depends on `moto` which has a long dependency chain with exact
  # version requirements that can't be made to work with current
  # pythonPackages.
  doCheck = false;

  meta = with stdenv.lib; {
    description = "S3FS builds on boto3 to provide a convenient Python filesystem interface for S3.";
    homepage = http://github.com/dask/s3fs/;
    license = licenses.bsd3;
    maintainers = with maintainers; [ teh ];
  };
}
