{ lib
, botocore
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, jmespath
, pytestCheckHook
, pythonOlder
, s3transfer
, pythonRelaxDepsHook
, setuptools
}:

buildPythonPackage rec {
  pname = "boto3";
  version = "1.34.21"; # N.B: if you change this, change botocore and awscli to a matching version
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "boto";
    repo = "boto3";
    rev = "refs/tags/${version}";
    hash = "sha256-oOrUVBh1sbaOibU8A+bGZ4z7IEiE4gjHwZ+8889Hv60=";
  };

  nativeBuildInputs = [
    pythonRelaxDepsHook
    setuptools
  ];

  pythonRelaxDeps = [
    "botocore"
    "s3transfer"
  ];

  propagatedBuildInputs = [
    botocore
    jmespath
    s3transfer
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "boto3"
  ];

  disabledTestPaths = [
    # Integration tests require networking
    "tests/integration"
  ];

  passthru.optional-dependencies = {
    crt = [
      botocore.optional-dependencies.crt
    ];
  };

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
