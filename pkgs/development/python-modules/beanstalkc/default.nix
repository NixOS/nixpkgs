{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  setuptools,
}:

buildPythonPackage rec {
  pname = "beanstalkc";
  version = "0.5.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bosondata";
    repo = "beanstalkc";
    rev = "v${version}";
    sha256 = "1dpb1yimp2pfnikmgsb2fr9x6h8riixlsx3xfqphnfvrid49vw5s";
  };

  build-system = [ setuptools ];

  doCheck = false;

  meta = {
    description = "Simple beanstalkd client library for Python";
    maintainers = with lib.maintainers; [ aanderse ];
    license = lib.licenses.asl20;
    homepage = "https://github.com/earl/beanstalkc";
  };
}
