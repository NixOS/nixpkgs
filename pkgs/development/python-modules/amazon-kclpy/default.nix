{ lib, buildPythonPackage, fetchFromGitHub, python, mock, boto, pytest }:

buildPythonPackage rec {
  pname = "amazon-kclpy";
  version = "2.1.1";

  src = fetchFromGitHub {
    owner = "awslabs";
    repo = "amazon-kinesis-client-python";
    rev = "refs/tags/v${version}";
    hash = "sha256-Z0MC4SbZS82beMA7UunEfs4KvrmhW5xAhFeb7WXA7DM=";
  };

  # argparse is just required for python2.6
  prePatch = ''
    substituteInPlace setup.py \
      --replace "'argparse'," ""
  '';

  propagatedBuildInputs =  [ mock boto ];

  nativeCheckInputs = [ pytest ];

  checkPhase = ''
    ${python.interpreter} -m pytest
  '';

  meta = with lib; {
    description = "Amazon Kinesis Client Library for Python";
    homepage = "https://github.com/awslabs/amazon-kinesis-client-python";
    license = licenses.amazonsl;
    maintainers = with maintainers; [ psyanticy ];
  };
}
