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
  version = "1.4.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pytries";
    repo = "marisa-trie";
    tag = version;
    hash = "sha256-U3gntlvJ0IaWoK+2V0OQ/XoDLfQsSbrrsSj95VR1m+4=";
  };

  patches = [
    (replaceVars ./unvendor-marisa.patch {
      marisa = lib.getDev marisa-cpp;
    })
  ];

  postPatch = ''
    # https://github.com/pytries/marisa-trie/issues/132
    substituteInPlace tests/test_binary_trie.py tests/test_trie.py \
      --replace-fail MARISA_FORMAT_ERROR std::runtime_error
  '';

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

  meta = {
    description = "Static memory-efficient Trie-like structures for Python based on marisa-trie C++ library";
    longDescription = ''
      There are official SWIG-based Python bindings included in C++ library distribution.
      This package provides alternative Cython-based pip-installable Python bindings.
    '';
    homepage = "https://github.com/kmike/marisa-trie";
    changelog = "https://github.com/pytries/marisa-trie/blob/${src.tag}/CHANGES.rst";
    license = lib.licenses.mit;
  };
}
