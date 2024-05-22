{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  stdenv,
  gcc12Stdenv,

  # build-system
  cython,
  setuptools,

  # tests
  numpy,
  unittestCheckHook,
}:

let
  stdenv' = if stdenv.isLinux then gcc12Stdenv else stdenv;
in
buildPythonPackage rec {
  pname = "faster-fifo";
  version = "1.4.5";
  format = "pyproject";

  # https://github.com/alex-petrenko/faster-fifo/issues/47\
  stdenv = stdenv';

  src = fetchFromGitHub {
    owner = "alex-petrenko";
    repo = "faster-fifo";
    rev = "v${version}";
    hash = "sha256-35kD+RWXwUXHG5leTVj4wY6hJAjDka69YczgSTIbCeg=";
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
