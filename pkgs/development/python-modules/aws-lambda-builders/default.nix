{ lib
, buildPythonPackage
, fetchPypi
, six
, setuptools
, wheel
}:

buildPythonPackage rec {
  pname = "aws-lambda-builders";
  version = "0.0.5";

  src = fetchPypi {
    inherit version;
    pname = "aws_lambda_builders";
    sha256 = "4380dd8430f443b46867ff2b03c9673ed6042a3ffc6f05c18764d062d04c4049";
  };

  doCheck = false;

  propagatedBuildInputs = [
    six
    setuptools
    wheel
  ];

  meta = with lib; {
    description = "Python library to compile, build & package AWS Lambda functions for several runtimes & frameworks.";
    homepage = https://github.com/awslabs/aws-lambda-builders;
    license = lib.licenses.asl20;
    maintainers = with maintainers; [ jnsaff ];
  };
}