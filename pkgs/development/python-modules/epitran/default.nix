{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  unittestCheckHook,

  setuptools,
  setuptools-scm,

  jamo,
  regex,
  panphon,
  marisa-trie,
  requests,
}:

buildPythonPackage rec {
  pname = "epitran";
  version = "1.35.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dmort27";
    repo = "epitran";
    tag = "v${version}";
    hash = "sha256-XXEZEptrVH+wfWm85B8yZ+RI+6AUZjWFKMjst/V7aE0=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    jamo
    regex
    panphon
    marisa-trie
    requests
  ];

  nativeCheckInputs = [ unittestCheckHook ];

  unittestFlagsArray = [
    "-s"
    "test"
  ];

  pythonImportsCheck = [
    "epitran"
    "epitran.backoff"
    "epitran.vector"
  ];

  meta = {
    description = "Tools for transcribing languages into IPA";
    homepage = "https://github.com/dmort27/epitran";
    changelog = "https://github.com/dmort27/epitran/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ vizid ];
  };
}
