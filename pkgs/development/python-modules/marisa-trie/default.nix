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
  version = "1.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pytries";
    repo = "marisa-trie";
    tag = version;
    hash = "sha256-7T0V5levh9xjWmjJdFix0p8L3lZhfurikSWMI7Hotbs=";
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
