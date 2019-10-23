{ buildPythonPackage, fetchPypi, lib, fs, six, boto3 }:

buildPythonPackage rec {
  pname = "fs-s3fs";
  version = "1.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0v4pqyflkpz6sp1884jfsxsa68wnxai4rd5la6sgf3s6civ8qzxm";
  };

  propagatedBuildInputs = [ fs six boto3 ];

  # tests try to integrate an s3 bucket which can't be tested properly in an isolated environment.
  doCheck = false;

  meta = with lib; {
    homepage = https://pypi.org/project/fs-s3fs/;
    license = licenses.mit;
    description = "Amazon S3 filesystem for PyFilesystem2";
    maintainers = with maintainers; [ ma27 ];
  };
}
