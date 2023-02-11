{ lib, buildPythonPackage, fetchFromGitHub, python, mock, boto, pytest }:

buildPythonPackage rec {
  pname = "amazon_kclpy";
  version = "2.0.6";

  src = fetchFromGitHub {
    owner = "awslabs";
    repo = "amazon-kinesis-client-python";
    rev = "v${version}";
    sha256 = "0gbpwhpd9i13vi0cch48qqrma90p230psqrkbfcjvdah69w434l4";
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
