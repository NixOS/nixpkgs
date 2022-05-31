{ stdenv
, lib
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
  version = "1.16.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "awslabs";
    repo = "aws-lambda-builders";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-XJDukyYTtnAHiHACi5gEJ9VPjqv8Y4V7oe4q3l5fpMA=";
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
    broken = (stdenv.isLinux && stdenv.isAarch64);
    description = "Tool to compile, build and package AWS Lambda functions";
    homepage = "https://github.com/awslabs/aws-lambda-builders";
    longDescription = ''
      Lambda Builders is a Python library to compile, build and package
      AWS Lambda functions for several runtimes & frameworks.
    '';
    license = licenses.asl20;
    maintainers = with maintainers; [ dhkl ];
  };
}
