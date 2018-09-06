{ stdenv, buildPythonPackage, fetchPypi, cryptography, boto3, pyyaml, docutils, nose }:

buildPythonPackage rec {
  pname = "credstash";
  version = "1.15.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "814560f99ae2409e2c6d906d878f9dadada5d1d0a950aafb6b2c0d535291bdfb";
  };

  nativeBuildInputs = [ nose ];

  propagatedBuildInputs = [ cryptography boto3 pyyaml docutils ];

  # No tests in archive
  doCheck = false;

  meta = with stdenv.lib; {
    description = "A utility for managing secrets in the cloud using AWS KMS and DynamoDB";
    homepage = https://github.com/LuminalOSS/credstash;
    license = licenses.asl20;
  };
}
