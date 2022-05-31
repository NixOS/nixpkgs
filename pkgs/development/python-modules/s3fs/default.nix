{ stdenv
, lib
, buildPythonPackage
, fetchPypi
, docutils
, aiobotocore
, fsspec
}:

buildPythonPackage rec {
  pname = "s3fs";
  version = "2022.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-RhHQ9+QeW8nawwCQcOCtN9qHpC9t73W0gTwG9+QEpzg=";
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
    broken = (stdenv.isLinux && stdenv.isAarch64) || stdenv.isDarwin;
    homepage = "https://github.com/dask/s3fs/";
    description = "A Pythonic file interface for S3";
    license = licenses.bsd3;
    maintainers = with maintainers; [ teh ];
  };
}
