{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "rtb-data";
  version = "1.0.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-xRKS3c31li5ZRWw6WrYqTVQKXqW91ONbKWP57Dglzx0=";
  };

  nativeBuildInputs = [ setuptools ];

  pythonImportsCheck = [ "rtbdata" ];

<<<<<<< HEAD
  meta = {
    description = "Data files for the Robotics Toolbox for Python";
    homepage = "https://pypi.org/project/rtb-data/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
=======
  meta = with lib; {
    description = "Data files for the Robotics Toolbox for Python";
    homepage = "https://pypi.org/project/rtb-data/";
    license = licenses.mit;
    maintainers = with maintainers; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      djacu
      a-camarillo
    ];
  };
}
