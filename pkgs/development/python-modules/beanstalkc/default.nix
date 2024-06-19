{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
}:

buildPythonPackage rec {
  pname = "beanstalkc";
  version = "0.5.2";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "bosondata";
    repo = "beanstalkc";
    rev = "v${version}";
    sha256 = "1dpb1yimp2pfnikmgsb2fr9x6h8riixlsx3xfqphnfvrid49vw5s";
  };

  doCheck = false;

  meta = with lib; {
    description = "A simple beanstalkd client library for Python";
    maintainers = with maintainers; [ aanderse ];
    license = licenses.asl20;
    homepage = "https://github.com/earl/beanstalkc";
  };
}
