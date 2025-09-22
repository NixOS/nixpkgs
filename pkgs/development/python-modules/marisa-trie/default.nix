{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  replaceVars,
  marisa-cpp,
  cython,
  setuptools,
  pytestCheckHook,
  hypothesis,
}:

buildPythonPackage rec {
  pname = "marisa-trie";
  version = "1.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pytries";
    repo = "marisa-trie";
    tag = version;
    hash = "sha256-aWfm13nrASAaD+bcMpv85emXnCFyVtZTdhl79yJuOss=";
  };

  patches = [
    (replaceVars ./unvendor-marisa.patch {
      marisa = lib.getDev marisa-cpp;
    })
  ];

  build-system = [
    cython
    setuptools
  ];

  buildInputs = [
    marisa-cpp
  ];

  nativeCheckInputs = [
    pytestCheckHook
    hypothesis
  ];

  preBuild = ''
    ./update_cpp.sh
  '';

  disabledTestPaths = [
    # Don't test packaging
    "tests/test_packaging.py"
  ];

  pythonImportsCheck = [ "marisa_trie" ];

  meta = with lib; {
    description = "Static memory-efficient Trie-like structures for Python based on marisa-trie C++ library";
    longDescription = ''
      There are official SWIG-based Python bindings included in C++ library distribution.
      This package provides alternative Cython-based pip-installable Python bindings.
    '';
    homepage = "https://github.com/kmike/marisa-trie";
    changelog = "https://github.com/pytries/marisa-trie/blob/${src.tag}/CHANGES.rst";
    license = licenses.mit;
  };
}
