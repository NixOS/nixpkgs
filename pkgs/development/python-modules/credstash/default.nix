{ stdenv, buildPythonPackage, fetchPypi, cryptography, boto3, pyyaml, docutils, nose }:

buildPythonPackage rec {
  pname = "credstash";
  version = "1.15.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "814560f99ae2409e2c6d906d878f9dadada5d1d0a950aafb6b2c0d535291bdfb";
  };

  # The install phase puts an executable and a copy of the library it imports in
  # bin/credstash and bin/credstash.py, despite the fact that the library is also
  # installed to lib/python<version>/site-packages/credstash.py.
  # If we apply wrapPythonPrograms to bin/credstash.py then the executable will try
  # to import the credstash module from the resulting shell script. Removing this
  # file ensures that Python imports the module from site-packages library.
  postInstall = "rm $out/bin/credstash.py";

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
