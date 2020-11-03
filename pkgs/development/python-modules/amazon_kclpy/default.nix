{ stdenv, buildPythonPackage, fetchFromGitHub, python, mock, boto, pytest }:

buildPythonPackage rec {
  pname = "amazon_kclpy";
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "awslabs";
    repo = "amazon-kinesis-client-python";
    rev = "v${version}";
    sha256 = "0jjqh9hq0hx2wr7wlqjr6cixpygragwlk4pz7rkqg2gkbhazmnq3";
  };

  # argparse is just required for python2.6
  prePatch = ''
    substituteInPlace setup.py \
      --replace "'argparse'," ""
  '';

  requiredPythonModules =  [ mock boto ];

  checkInputs = [ pytest ];

  checkPhase = ''
    ${python.interpreter} -m pytest
  '';

  meta = with stdenv.lib; {
    description = "Amazon Kinesis Client Library for Python";
    homepage = "https://github.com/awslabs/amazon-kinesis-client-python";
    license = licenses.amazonsl;
    maintainers = with maintainers; [ psyanticy ];
  };
}
