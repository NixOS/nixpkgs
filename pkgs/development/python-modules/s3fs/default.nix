{ stdenv, buildPythonPackage, fetchPypi, docutils, boto3 }:

buildPythonPackage rec {
  pname = "s3fs";
  version = "0.1.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4fbab74d72ceeb1a6f249165bde7b1d1c4dd758390339f52c84f0832bc5117a7";
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
