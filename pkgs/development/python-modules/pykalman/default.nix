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
  version = "0.10.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pykalman";
    repo = "pykalman";
    tag = "v${version}";
    hash = "sha256-9HaDNYVPdRvQH3r5j7r0uHqyuR6HqV7QaNuxKEYDcy8=";
  };

  build-system = [ setuptools ];

  dependencies = [
    numpy
    scipy
    scikit-base
  ];

  nativeCheckInputs = [ pytestCheckHook ];
  pythonImportsCheck = [ "pykalman" ];

  meta = with lib; {
    description = "Implementation of the Kalman Filter, Kalman Smoother, and EM algorithm in Python";
    homepage = "https://github.com/pykalman/pykalman";
    license = licenses.bsd2;
    maintainers = with maintainers; [ mbalatsko ];
  };
}
