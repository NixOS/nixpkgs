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
  version = "0.3.0";

  # No tests available in PyPI tarball
  src = fetchFromGitHub {
    owner = "awslabs";
    repo = "aws-lambda-builders";
    rev = "v${version}";
    sha256 = "1c3r3iz29s68mlmdsxbl65x5zqx25b89d40rir6729ck4gll4dyd";
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
    pytest tests/functional
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
