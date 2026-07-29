{
  lib,
  awscrt,
  cacert,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  jmespath,
  python-dateutil,
  urllib3,

  # tests
  jsonschema,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "botocore";
  version = "1.43.56"; # N.B: if you change this, change boto3 and awscli to a matching version
  pyproject = true;

  src = fetchFromGitHub {
    owner = "boto";
    repo = "botocore";
    tag = finalAttrs.version;
    hash = "sha256-Z0KbNZ9Kyl70vyKVLWT46bHaE5e/k0LKDvGQRLf+pXY=";
  };

  postPatch = ''
    ln -sf ${cacert}/etc/ssl/certs/ca-no-trust-rules-bundle.crt botocore/cacert.pem
  '';

  build-system = [
    setuptools
  ];

  dependencies = [
    jmespath
    python-dateutil
    urllib3
  ];

  nativeCheckInputs = [
    jsonschema
    pytestCheckHook
  ];

  disabledTestPaths = [
    # Integration tests require networking
    "tests/integration"

    # Disable slow tests (only run unit tests)
    "tests/functional"
  ];

  pythonImportsCheck = [ "botocore" ];

  optional-dependencies = {
    crt = [ awscrt ];
  };

  meta = {
    description = "Low-level interface to a growing number of Amazon Web Services";
    homepage = "https://github.com/boto/botocore";
    changelog = "https://github.com/boto/botocore/blob/${finalAttrs.src.tag}/CHANGELOG.rst";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ anthonyroussel ];
  };
})
