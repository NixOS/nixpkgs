{
  lib,
  boto3,
  buildPythonPackage,
  cryptography,
  docutils,
  fetchFromGitHub,
  fetchpatch,
  pytestCheckHook,
  pythonOlder,
  pyyaml,
  setuptools,
}:

buildPythonPackage rec {
  pname = "credstash";
  version = "1.17.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "fugue";
    repo = "credstash";
    rev = "refs/tags/v${version}";
    hash = "sha256-a6OzffGt5piHgi0AWEXJED0R/+8RETh/9hYJi/lUVu0=";
  };

  patches = [
    # setup_requires -> tests_requires for pytest
    (fetchpatch {
      url = "https://github.com/fugue/credstash/commit/9c02ee43ed6e37596cafbca2fe80c532ec19d2d8.patch";
      hash = "sha256-dlybrpfLK+PqwWWhH9iXgXHYysZGmcZAFGWNOwsG0xA=";
    })
  ];
  # The install phase puts an executable and a copy of the library it imports in
  # bin/credstash and bin/credstash.py, despite the fact that the library is also
  # installed to lib/python<version>/site-packages/credstash.py.
  # If we apply wrapPythonPrograms to bin/credstash.py then the executable will try
  # to import the credstash module from the resulting shell script. Removing this
  # file ensures that Python imports the module from site-packages library.
  postInstall = "rm $out/bin/credstash.py";

  build-system = [ setuptools ];

  dependencies = [
    boto3
    cryptography
    docutils
    pyyaml
  ];

  nativeBuildInputs = [ pytestCheckHook ];

  disabledTestPaths = [
    # Tests require a region
    "integration_tests/test_credstash_lib.py"
    "tests/key_service_test.py"
  ];

  meta = with lib; {
    description = "Utility for managing secrets in the cloud using AWS KMS and DynamoDB";
    homepage = "https://github.com/LuminalOSS/credstash";
    changelog = "https://github.com/fugue/credstash/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
    mainProgram = "credstash";
  };
}
