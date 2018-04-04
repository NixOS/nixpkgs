{ stdenv, buildPythonPackage, fetchPypi, docutils, boto3 }:

buildPythonPackage rec {
  pname = "s3fs";
  version = "0.0.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0zbdzqrim0zig94fk1hswg4vfdjplw6jpx3pdi42qc830h0nscn8";
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
