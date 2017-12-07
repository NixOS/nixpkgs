{ stdenv, buildPythonPackage, fetchPypi, cryptography, boto3, pyyaml, docutils }:

buildPythonPackage rec {
  pname    = "credstash";
  version = "1.13.4";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "676cc03a6143dec260c78aeef09d08a64faf27c411f8a94f6d9338e985879f81";
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
