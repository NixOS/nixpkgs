{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  wheel,
  black,
  codecov,
  coverage,
  librosa,
  numpy,
  pre-commit,
  pytest,
  scipy,
  torch,
}:

buildPythonPackage rec {
  pname = "asteroid-filterbanks";
  version = "0.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "asteroid-team";
    repo = "asteroid-filterbanks";
    rev = "v${version}";
    hash = "sha256-Z5M2Xgj83lzqov9kCw/rkjJ5KXbjuP+FHYCjhi5nYFE=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  propagatedBuildInputs = [
    black
    codecov
    coverage
    librosa
    numpy
    pre-commit
    pytest
    scipy
    torch
  ];

  pythonImportsCheck = [ "asteroid_filterbanks" ];

  meta = with lib; {
    description = "PyTorch-based audio source separation toolkit for researchers";
    homepage = "https://github.com/asteroid-team/asteroid-filterbanks";
    license = licenses.mit;
    maintainers = with maintainers; [ matthewcroughan ];
  };
}
