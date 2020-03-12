{ stdenv, buildPythonPackage, fetchPypi, docutils, boto3, fsspec }:

buildPythonPackage rec {
  pname = "s3fs";
  version = "0.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "504a41ecb9edf0bd7798847b61839954e50508c5235ec7ee48c539ce46b4fa18";
  };

  buildInputs = [ docutils ];
  propagatedBuildInputs = [ boto3 fsspec ];

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
