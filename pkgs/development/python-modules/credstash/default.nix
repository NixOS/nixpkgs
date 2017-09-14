{ stdenv, buildPythonPackage, fetchPypi, cryptography, boto3, pyyaml, docutils }:

buildPythonPackage rec {
  pname    = "credstash";
  version = "1.13.3";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1x2dh4rs5sahb8h2xznhq7srcm2zl9ykc72a8iqpq4dz7l9k7x7i";
  };

  propagatedBuildInputs = [ cryptography boto3 pyyaml docutils ];

  # No tests in archive
  doCheck = false;

  meta = with stdenv.lib; {
    description = "A utility for managing secrets in the cloud using AWS KMS and DynamoDB";
    homepage = https://github.com/LuminalOSS/credstash;
    license = licenses.asl20;
  };
}
