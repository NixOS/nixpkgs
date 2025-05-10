{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  cython,
  setuptools,
  hypothesis,
  pytestCheckHook,
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
    cython
    setuptools
  ];

  pythonImportsCheck = [ "pyroaring" ];

  nativeCheckInputs = [
    hypothesis
    pytestCheckHook
  ];

  meta = {
    description = "Python library for handling efficiently sorted integer sets";
    homepage = "https://github.com/Ezibenroc/PyRoaringBitMap";
    changelog = "https://github.com/Ezibenroc/PyRoaringBitMap/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ drupol ];
  };
}
