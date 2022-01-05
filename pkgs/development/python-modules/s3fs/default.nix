{ lib
, buildPythonPackage
, fetchPypi
, docutils
, aiobotocore
, fsspec
}:

buildPythonPackage rec {
  pname = "s3fs";
  version = "2021.11.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3c23eac1fa5b685c9d507950b24f75929e8bcd1ea98b9a95cf2a9cb66ee6c9f5";
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
    homepage = "https://github.com/dask/s3fs/";
    description = "A Pythonic file interface for S3";
    license = licenses.bsd3;
    maintainers = with maintainers; [ teh ];
  };
}
