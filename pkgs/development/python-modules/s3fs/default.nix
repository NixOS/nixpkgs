{ lib, buildPythonPackage, fetchPypi, docutils, aiobotocore, fsspec }:

buildPythonPackage rec {
  pname = "s3fs";
  version = "0.5.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7396943cbc1cf92eb6f7aa93be5f64a3bfa59d76908262e89bae06e3c87fa59d";
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
