{ lib
, botocore
, buildPythonPackage
, fetchFromGitHub
, jmespath
, pytest-xdist
, pytestCheckHook
, pythonOlder
, pythonRelaxDepsHook
, s3transfer
, setuptools
}:

buildPythonPackage rec {
  pname = "boto3";
  version = "1.34.73"; # N.B: if you change this, change botocore and awscli to a matching version
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "boto";
    repo = "boto3";
    rev = "refs/tags/${version}";
    hash = "sha256-v/pk9j7fschNJvDI7oXXyfU4jjDKDoh/jsH1MdfMFjs=";
  };

  pythonRelaxDeps = [
    "s3transfer"
  ];

  build-system = [
    pythonRelaxDepsHook
    setuptools
  ];

  dependencies = [
    botocore
    jmespath
    s3transfer
  ];

  passthru.optional-dependencies = {
    crt = [
      botocore
    ] ++ botocore.optional-dependencies.crt;
  };

  nativeCheckInputs = [
    pytest-xdist
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "boto3"
  ];

  disabledTestPaths = [
    # Integration tests require networking
    "tests/integration"
  ];

  meta = with lib; {
    description = "AWS SDK for Python";
    homepage = "https://github.com/boto/boto3";
    changelog = "https://github.com/boto/boto3/blob/${version}/CHANGELOG.rst";
    license = licenses.asl20;
    longDescription = ''
      Boto3 is the Amazon Web Services (AWS) Software Development Kit (SDK) for
      Python, which allows Python developers to write software that makes use of
      services like Amazon S3 and Amazon EC2.
    '';
    maintainers = with maintainers; [ anthonyroussel ];
  };
}
