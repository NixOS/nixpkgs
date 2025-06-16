{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  numpy,
  scipy,
  matplotlib,
  setuptools,
  setuptools-scm,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "python-control";
  version = "0.10.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "python-control";
    repo = "python-control";
    tag = version;
    sha256 = "sha256-wLDYPuLnsZ2+cXf7j3BxUbn4IjHPt09LE9cjQGXWrO0=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    numpy
    scipy
    matplotlib
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "Python Control Systems Library";
    homepage = "https://github.com/python-control/python-control";
    license = licenses.bsd3;
    maintainers = with maintainers; [ Peter3579 ];
  };
}
