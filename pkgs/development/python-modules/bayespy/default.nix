{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  numpy,
  scipy,
  h5py,
  truncnorm,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "bayespy";
  version = "0.6.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bayespy";
    repo = "bayespy";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-kx87XY4GCL1PQIeZyovEbrPyCC/EVA6Hdvt+3P/D6VI=";
=======
    hash = "sha256-X7CwJBrKHlU1jqMkt/7XEzaiwul1Yzkb/V64lXG4Aqo=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  postPatch = ''
    substituteInPlace versioneer.py \
      --replace-fail SafeConfigParser ConfigParser \
      --replace-fail readfp read_file
  '';

  build-system = [ setuptools ];

  dependencies = [
    numpy
    scipy
    h5py
    truncnorm
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "bayespy" ];

<<<<<<< HEAD
  meta = {
    homepage = "http://www.bayespy.org";
    description = "Variational Bayesian inference tools for Python";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jluttine ];
=======
  meta = with lib; {
    homepage = "http://www.bayespy.org";
    description = "Variational Bayesian inference tools for Python";
    license = licenses.mit;
    maintainers = with maintainers; [ jluttine ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
