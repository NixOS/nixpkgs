{
  lib,
  buildPythonPackage,
  fetchPypi,
  numpy,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "fastprogress";
<<<<<<< HEAD
  version = "1.0.5";
=======
  version = "1.0.3";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  format = "setuptools";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-WMoWqYHwKSgE2QXy4AQq1gjXiL9svmq5a3HsSyBFOu8=";
=======
    hash = "sha256-ehfStDiJD4OMBI7vzjLE3tRxl+zI6gQs7MM9PeuAIvU=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  propagatedBuildInputs = [ numpy ];

  # no real tests
  doCheck = false;
  pythonImportsCheck = [ "fastprogress" ];

<<<<<<< HEAD
  meta = {
    homepage = "https://github.com/fastai/fastprogress";
    description = "Simple and flexible progress bar for Jupyter Notebook and console";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ris ];
=======
  meta = with lib; {
    homepage = "https://github.com/fastai/fastprogress";
    description = "Simple and flexible progress bar for Jupyter Notebook and console";
    license = licenses.asl20;
    maintainers = with maintainers; [ ris ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
