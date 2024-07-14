{
  lib,
  buildPythonPackage,
  fetchPypi,
  isPy27,
  pythonAtLeast,
  keras,
  numpy,
  scipy,
  six,
  tensorflow,
}:

buildPythonPackage rec {
  pname = "edward";
  version = "1.3.5";
  format = "setuptools";

  disabled = !(isPy27 || pythonAtLeast "3.4");

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-OBiznnfCb8Gjd2enT91efQKHfXXtkB6tL0C9A7qqEJ8=";
  };

  # disabled for now due to Tensorflow trying to create files in $HOME:
  doCheck = false;

  propagatedBuildInputs = [
    keras
    numpy
    scipy
    six
    tensorflow
  ];

  meta = with lib; {
    description = "Probabilistic programming language using Tensorflow";
    homepage = "https://github.com/blei-lab/edward";
    license = licenses.asl20;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
