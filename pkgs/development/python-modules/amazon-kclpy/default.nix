{ lib, buildPythonPackage, fetchFromGitHub, python, mock, boto, pytest }:

buildPythonPackage rec {
  pname = "amazon-kclpy";
  version = "2.1.3";

  src = fetchFromGitHub {
    owner = "awslabs";
    repo = "amazon-kinesis-client-python";
    rev = "refs/tags/v${version}";
    hash = "sha256-3BhccRJd6quElXZSix1aVIqWr9wdcTTziDhnIOLiPPo=";
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
