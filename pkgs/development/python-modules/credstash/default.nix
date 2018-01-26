{ stdenv, buildPythonPackage, fetchPypi, cryptography, boto3, pyyaml, docutils }:

buildPythonPackage rec {
  pname    = "credstash";
  version = "1.14.0";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "718b337f7a6fa001e014386071f05c59900525d0507009126d2fe8d75fe0761d";
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
