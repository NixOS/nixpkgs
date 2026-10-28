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
    hash = "sha256-tX+MdmRGD/e0UbS0TKLqliOjdNdOEoTC1ebfSZ3Hl2w=";
  };

  propagatedBuildInputs = [
    fs
    six
    boto3
  ];

  # tests try to integrate an s3 bucket which can't be tested properly in an isolated environment.
  doCheck = false;

  meta = {
    homepage = "https://pypi.org/project/fs-s3fs/";
    license = lib.licenses.mit;
    description = "Amazon S3 filesystem for PyFilesystem2";
    maintainers = [ ];
  };
}
