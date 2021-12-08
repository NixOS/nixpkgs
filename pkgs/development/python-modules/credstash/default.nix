{ lib, buildPythonPackage, fetchFromGitHub, cryptography, boto3, pyyaml, docutils, pytest, fetchpatch }:

buildPythonPackage rec {
  pname = "credstash";
  version = "1.17.1";

  src = fetchFromGitHub {
     owner = "LuminalOSS";
     repo = "credstash";
     rev = "v1.17.1";
     sha256 = "1vanakwqn28nyrzkh48ixzzi2g8hr52mh01dha3rirmdy5yv78vb";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/fugue/credstash/commit/9c02ee43ed6e37596cafbca2fe80c532ec19d2d8.patch";
      sha256 = "dlybrpfLK+PqwWWhH9iXgXHYysZGmcZAFGWNOwsG0xA=";
    })
  ];
  # The install phase puts an executable and a copy of the library it imports in
  # bin/credstash and bin/credstash.py, despite the fact that the library is also
  # installed to lib/python<version>/site-packages/credstash.py.
  # If we apply wrapPythonPrograms to bin/credstash.py then the executable will try
  # to import the credstash module from the resulting shell script. Removing this
  # file ensures that Python imports the module from site-packages library.
  postInstall = "rm $out/bin/credstash.py";

  nativeBuildInputs = [ pytest ];

  propagatedBuildInputs = [ cryptography boto3 pyyaml docutils ];

  # No tests in archive
  doCheck = false;

  meta = with lib; {
    description = "A utility for managing secrets in the cloud using AWS KMS and DynamoDB";
    homepage = "https://github.com/LuminalOSS/credstash";
    license = licenses.asl20;
  };
}
