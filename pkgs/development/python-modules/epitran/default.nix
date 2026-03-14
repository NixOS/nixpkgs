{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  unittestCheckHook,

  setuptools,

  regex,
  panphon,
  marisa-trie,
  requests,
}:

buildPythonPackage rec {
  pname = "epitran";
  version = "1.34.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dmort27";
    repo = "epitran";
    tag = "v${version}";
    hash = "sha256-LKESBSLn2gpXx8kEXmykEkTboIMiS5gZ2Kb9rj1lDTk=";
  };

  build-system = [ setuptools ];

  dependencies = [
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
