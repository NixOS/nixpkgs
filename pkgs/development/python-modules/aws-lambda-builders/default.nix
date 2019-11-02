{ lib
, buildPythonPackage
, fetchFromGitHub
, six
, pytest
, mock
, parameterized
, isPy35
}:

buildPythonPackage rec {
  pname = "aws-lambda-builders";
  version = "0.4.0";

  # No tests available in PyPI tarball
  src = fetchFromGitHub {
    owner = "awslabs";
    repo = "aws-lambda-builders";
    rev = "v${version}";
    sha256 = "1z2l9qm6mxp90zl64i9j2cmlzn8n7sc8yfpqh14fi9ay887ayjs1";
  };

  # Package is not compatible with Python 3.5
  disabled = isPy35;

  propagatedBuildInputs = [
    six
  ];

  checkInputs = [
    pytest
    mock
    parameterized
  ];

  checkPhase = ''
    export PATH=$out/bin:$PATH
    pytest tests/functional -k 'not can_invoke_pip'
  '';

  meta = with lib; {
    homepage = https://github.com/awslabs/aws-lambda-builders;
    description = "A tool to compile, build and package AWS Lambda functions";
    longDescription = ''
      Lambda Builders is a Python library to compile, build and package
      AWS Lambda functions for several runtimes & frameworks.
    '';
    license = licenses.asl20;
    maintainers = with maintainers; [ dhkl ];
  };
}
