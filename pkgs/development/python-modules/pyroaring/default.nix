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
    (cython.overrideAttrs (rec {
      name = "cython";
      version = "3.0.12";
      src = fetchFromGitHub {
        owner = "cython";
        repo = "cython";
        tag = version;
        hash = "sha256-clJXjQb6rVECirKRUGX0vD5a6LILzPwNo7+6KKYs2pI=";
      };
    }))
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
