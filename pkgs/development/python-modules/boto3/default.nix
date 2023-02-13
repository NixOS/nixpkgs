{ lib
, buildPythonPackage
, fetchFromGitHub
, botocore
, jmespath
, s3transfer
, setuptools
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "boto3";
  version = "1.26.38"; # N.B: if you change this, change botocore and awscli to a matching version
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "boto";
    repo = pname;
    rev = version;
    hash = "sha256-/QkR6gL0XkXofnFDcKa7J0ZbZbgT0IKnqtq2wcilbEs=";
  };

  propagatedBuildInputs = [
    botocore
    jmespath
    s3transfer
    setuptools
  ];

  doCheck = true;

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

  meta = with lib; {
    homepage = "https://github.com/boto/boto3";
    changelog = "https://github.com/boto/boto3/blob/${version}/CHANGELOG.rst";
    license = licenses.asl20;
    description = "AWS SDK for Python";
    longDescription = ''
      Boto3 is the Amazon Web Services (AWS) Software Development Kit (SDK) for
      Python, which allows Python developers to write software that makes use of
      services like Amazon S3 and Amazon EC2.
    '';
    maintainers = with maintainers; [ anthonyroussel ];
  };
}
