{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  numpy,
  scipy,
  scikit-base,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pykalman";
<<<<<<< HEAD
  version = "0.11.0";
=======
  version = "0.10.2";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pykalman";
    repo = "pykalman";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-wV7QxChTPKUBpCNs1afLGvpfbWJx9R8nbC9X973T74U=";
=======
    hash = "sha256-SMK0b2twlHk4sbNfwWafqDYXlhrZhgpaC1nhv2XQaqo=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = [ setuptools ];

  dependencies = [
    numpy
    scipy
    scikit-base
  ];

  pythonRelaxDeps = [ "scikit-base" ];

  nativeCheckInputs = [ pytestCheckHook ];
  pythonImportsCheck = [ "pykalman" ];

<<<<<<< HEAD
  meta = {
    description = "Implementation of the Kalman Filter, Kalman Smoother, and EM algorithm in Python";
    homepage = "https://github.com/pykalman/pykalman";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ mbalatsko ];
=======
  meta = with lib; {
    description = "Implementation of the Kalman Filter, Kalman Smoother, and EM algorithm in Python";
    homepage = "https://github.com/pykalman/pykalman";
    license = licenses.bsd2;
    maintainers = with maintainers; [ mbalatsko ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
