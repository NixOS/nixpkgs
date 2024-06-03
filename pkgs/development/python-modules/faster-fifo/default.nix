{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  cython,
  setuptools,

  # tests
  numpy,
  unittestCheckHook,
}:

buildPythonPackage rec {
  pname = "faster-fifo";
  version = "1.4.6";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "alex-petrenko";
    repo = "faster-fifo";
    rev = "v${version}";
    hash = "sha256-vgaaIJTtNg2XqEZ9TB7tTMPJ9yMyWjtfdgNU/lcNLcg=";
  };

  nativeBuildInputs = [
    cython
    setuptools
  ];

  pythonImportsCheck = [ "faster_fifo" ];

  nativeCheckInputs = [
    numpy
    unittestCheckHook
  ];

  meta = with lib; {
    description = "Faster alternative to Python's multiprocessing.Queue (IPC FIFO queue";
    homepage = "https://github.com/alex-petrenko/faster-fifo";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
