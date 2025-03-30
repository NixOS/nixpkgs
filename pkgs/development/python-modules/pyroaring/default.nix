{
  lib,
  fetchFromGitHub,
  buildPythonPackage,

  # build-system
  setuptools,
  wheel,
  cython,

  # tests
  pytest,
  hypothesis,
  unittestCheckHook,
}:

buildPythonPackage rec {
  pname = "pyroaring";
  version = "1.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Ezibenroc";
    repo = "PyRoaringBitMap";
    tag = version;
    hash = "sha256-pnANvqyQ5DpG4NWSgWkAkXvSNLO67nfa97nEz3fYf1Y=";
  };

  build-system = [
    setuptools
    wheel
    cython
  ];

  nativeCheckInputs = [
    pytest
    hypothesis
    unittestCheckHook
  ];

  pythonImportsCheck = [
    "pyroaring"
  ];

  meta = {
    description = "Library for handling efficiently sorted integer sets";
    homepage = "https://github.com/Ezibenroc/PyRoaringBitMap";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ezibenroc ];
    mainProgram = "pyroaring";
  };
}
