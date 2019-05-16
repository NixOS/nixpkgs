{ buildPythonPackage, fetchPypi, lib, fs, six, boto3 }:

buildPythonPackage rec {
  pname = "fs-s3fs";
  version = "1.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "49bfa4572bb11e37324dd43be935ab99376259eff652365aef0e4a747bb11418";
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
