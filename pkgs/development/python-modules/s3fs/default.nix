{ stdenv, buildPythonPackage, fetchPypi, docutils, boto3 }:

buildPythonPackage rec {
  pname = "s3fs";
  version = "0.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2146aae91ba3a06d7bfa7130688219599f8696d2825fb00f62923bb56f6e7ed3";
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
