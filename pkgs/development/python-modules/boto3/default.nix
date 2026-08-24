{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  botocore,
  jmespath,
  s3transfer,

  # tests
  pytest-xdist,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "boto3";
  inherit (botocore) version; # N.B: botocore, boto3, awscli needs to be updated in lockstep, bump botocore version for updating these.
  pyproject = true;

  src = fetchFromGitHub {
    owner = "boto";
    repo = "boto3";
    tag = finalAttrs.version;
    hash = "sha256-fzwVxbn4+5zkcAKQ9+bEbNSdwcPKZqsNIJZPqhV+n8w=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "version=get_version()," "version='${finalAttrs.version}'," 
  '';

  pythonRelaxDeps = [
    "botocore"
    "s3transfer"
  ];

  build-system = [ setuptools ];

  dependencies = [
    botocore
    jmespath
    s3transfer
  ];

  optional-dependencies = {
    crt = botocore.optional-dependencies.crt;
  };

  nativeCheckInputs = [
    pytest-xdist
    pytestCheckHook
  ]
   ++ lib.flatten (builtins.attrValues finalAttrs.passthru.optional-dependencies);

  pythonImportsCheck = [ "boto3" ];

  disabledTestPaths = [
    # Integration tests require networking
    "tests/integration"
    # RuntimeError due to verification certificate
    "tests/functional/test_crt.py"
    "tests/unit/test_crt.py"
  ];

  disabledTests = [
    # AssertionError
    "test_copy_progress"
  ];

  meta = {
    description = "AWS SDK for Python";
    homepage = "https://github.com/boto/boto3";
    changelog = "https://github.com/boto/boto3/blob/${finalAttrs.version}/CHANGELOG.rst";
    license = lib.licenses.asl20;
    longDescription = ''
      Boto3 is the Amazon Web Services (AWS) Software Development Kit (SDK) for
      Python, which allows Python developers to write software that makes use of
      services like Amazon S3 and Amazon EC2.
    '';
    maintainers = with lib.maintainers; [ anthonyroussel ];
  };
})
