{
  buildPythonPackage,
  fetchPypi,
  lib,
  fs,
  six,
  boto3,
}:

buildPythonPackage rec {
  pname = "fs-s3fs";
  version = "1.1.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b57f8c7664460ff7b451b4b44ca2ea9623a374d74e1284c2d5e6df499dc7976c";
  };

  propagatedBuildInputs = [
    fs
    six
    boto3
  ];

  # tests try to integrate an s3 bucket which can't be tested properly in an isolated environment.
  doCheck = false;

  meta = with lib; {
    homepage = "https://pypi.org/project/fs-s3fs/";
    license = licenses.mit;
    description = "Amazon S3 filesystem for PyFilesystem2";
    maintainers = with maintainers; [ ];
  };
}
