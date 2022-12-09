{ lib
, buildPythonPackage
, fetchPypi
, botocore
, jmespath
, s3transfer
}:

buildPythonPackage rec {
  pname = "boto3";
  version = "1.26.27"; # N.B: if you change this, change botocore and awscli to a matching version

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-JVp1ZSJsIcXVAPaaq7l34awH269Xb0Qo0AVY6OUIojs=";
  };

  propagatedBuildInputs = [
    botocore
    jmespath
    s3transfer
  ];

  # boto3 Pypi package has no tests.
  doCheck = false;

  pythonImportsCheck = [
    "boto3"
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
