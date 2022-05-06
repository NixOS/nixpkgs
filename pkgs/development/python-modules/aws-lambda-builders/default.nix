{ lib
, buildPythonPackage
, fetchFromGitHub
, six
, pytest
, mock
, parameterized
, pythonOlder
}:

buildPythonPackage rec {
  pname = "aws-lambda-builders";
  version = "1.15.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "awslabs";
    repo = "aws-lambda-builders";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-kXglpj82e+LzUI6SW86wyfG2lGVnL/PsrTNsseg4VYk=";
  };

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
    homepage = "https://github.com/awslabs/aws-lambda-builders";
    description = "A tool to compile, build and package AWS Lambda functions";
    longDescription = ''
      Lambda Builders is a Python library to compile, build and package
      AWS Lambda functions for several runtimes & frameworks.
    '';
    license = licenses.asl20;
    maintainers = with maintainers; [ dhkl ];
  };
}
