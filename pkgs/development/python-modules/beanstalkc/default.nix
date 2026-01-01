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

<<<<<<< HEAD
  meta = {
    description = "Simple beanstalkd client library for Python";
    maintainers = with lib.maintainers; [ aanderse ];
    license = lib.licenses.asl20;
=======
  meta = with lib; {
    description = "Simple beanstalkd client library for Python";
    maintainers = with maintainers; [ aanderse ];
    license = licenses.asl20;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    homepage = "https://github.com/earl/beanstalkc";
  };
}
