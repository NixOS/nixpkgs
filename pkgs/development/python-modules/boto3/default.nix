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
<<<<<<< HEAD
  version = "1.28.9"; # N.B: if you change this, change botocore and awscli to a matching version
=======
  version = "1.26.79"; # N.B: if you change this, change botocore and awscli to a matching version
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "boto";
    repo = pname;
    rev = version;
<<<<<<< HEAD
    hash = "sha256-NkNHA20yn1Q7uoq/EL1Wn8F1fpi1waQujutGIKsnxlI=";
  };

  nativeBuildInputs = [
    setuptools
  ];

=======
    hash = "sha256-9Xsng4xZ+IGNZ3ViYVrOyKZdRH6QPSjZALj9Q3HECBU=";
  };

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  propagatedBuildInputs = [
    botocore
    jmespath
    s3transfer
<<<<<<< HEAD
  ];

=======
    setuptools
  ];

  doCheck = true;

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
