{ stdenv, buildPythonPackage, fetchPypi, docutils, boto3 }:

buildPythonPackage rec {
  pname = "s3fs";
  version = "0.3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f1d8d80ae7789e6c95f8432e3ec12d1c28e624aecf8c84afed373fb182b505ab";
  };

  buildInputs = [ docutils ];
  propagatedBuildInputs = [ boto3 ];

  # Depends on `moto` which has a long dependency chain with exact
  # version requirements that can't be made to work with current
  # pythonPackages.
  doCheck = false;

  meta = with stdenv.lib; {
    description = "S3FS builds on boto3 to provide a convenient Python filesystem interface for S3.";
    homepage = https://github.com/dask/s3fs/;
    license = licenses.bsd3;
    maintainers = with maintainers; [ teh ];
  };
}
