{ lib, buildPythonPackage, fetchPypi, docutils, aiobotocore, fsspec }:

buildPythonPackage rec {
  pname = "s3fs";
  version = "0.5.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "87e5210415db17b9de18c77bcfc4a301570cc9030ee112b77dc47ab82426bae1";
  };

  buildInputs = [ docutils ];
  propagatedBuildInputs = [ aiobotocore fsspec ];

  # Depends on `moto` which has a long dependency chain with exact
  # version requirements that can't be made to work with current
  # pythonPackages.
  doCheck = false;

  meta = with lib; {
    description = "S3FS builds on boto3 to provide a convenient Python filesystem interface for S3.";
    homepage = "https://github.com/dask/s3fs/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ teh ];
  };
}
