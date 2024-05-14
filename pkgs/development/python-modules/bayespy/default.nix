{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
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

  # Python 2 not supported and not some old Python 3 because MPL doesn't support
  # them properly.
  disabled = pythonOlder "3.4";

  src = fetchFromGitHub {
    owner = "bayespy";
    repo = "bayespy";
    rev = "refs/tags/${version}";
    hash = "sha256-X7CwJBrKHlU1jqMkt/7XEzaiwul1Yzkb/V64lXG4Aqo=";
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

  meta = with lib; {
    homepage = "http://www.bayespy.org";
    description = "Variational Bayesian inference tools for Python";
    license = licenses.mit;
    maintainers = with maintainers; [ jluttine ];
  };
}
