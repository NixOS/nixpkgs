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
  version = "1.24";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dmort27";
    repo = "epitran";
    tag = version;
    hash = "sha256-AH4q8J5oMaUVJ559qe/ZlJXlCcGdxWnxMhnZKCH5Rlk=";
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

  meta = with lib; {
    description = "Tools for transcribing languages into IPA";
    homepage = "https://github.com/dmort27/epitran";
    changelog = "https://github.com/dmort27/epitran/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ vizid ];
  };
}
