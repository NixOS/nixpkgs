{ lib, buildPythonPackage, fetchFromGitHub, python, mock, boto, pytest }:

buildPythonPackage rec {
  pname = "amazon_kclpy";
  version = "2.0.2";

  src = fetchFromGitHub {
    owner = "awslabs";
    repo = "amazon-kinesis-client-python";
    rev = "v${version}";
    sha256 = "12yxcwml6g86sv1pj3wc2k97md9szdj6xx07qwri1mr9bdkzw7rv";
  };

  # argparse is just required for python2.6
  prePatch = ''
    substituteInPlace setup.py \
      --replace "'argparse'," ""
  '';

  propagatedBuildInputs =  [ mock boto ];

  checkInputs = [ pytest ];

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
