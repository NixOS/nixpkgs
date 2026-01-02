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
    hash = "sha256-kx87XY4GCL1PQIeZyovEbrPyCC/EVA6Hdvt+3P/D6VI=";
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

  meta = {
    homepage = "http://www.bayespy.org";
    description = "Variational Bayesian inference tools for Python";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jluttine ];
  };
}
