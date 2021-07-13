{ lib
, buildPythonPackage
, fetchPypi
, docutils
, aiobotocore
, fsspec
}:

buildPythonPackage rec {
  pname = "s3fs";
  version = "2021.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "53790061e220713918602c1f110e6a84d6e3e22aaba27b8e134cc56a3ab6284c";
  };

  buildInputs = [
    docutils
  ];

  propagatedBuildInputs = [
    aiobotocore
    fsspec
  ];

  # Depends on `moto` which has a long dependency chain with exact
  # version requirements that can't be made to work with current
  # pythonPackages.
  doCheck = false;

  pythonImportsCheck = [ "s3fs" ];

  meta = with lib; {
    description = "S3FS builds on boto3 to provide a convenient Python filesystem interface for S3";
    homepage = "https://github.com/dask/s3fs/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ teh ];
  };
}
