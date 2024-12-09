{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "pyahocorasick";
  version = "2.1.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "WojciechMula";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-SCIgu0uEjiSUiIP0WesJG+y+3ZqFBfI5PdgUzviOVrs=";
  };

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "ahocorasick" ];

  meta = with lib; {
    description = "Python module implementing Aho-Corasick algorithm";
    longDescription = ''
      This Python module is a fast and memory efficient library for exact or
      approximate multi-pattern string search meaning that you can find multiple
      key strings occurrences at once in some input text.
    '';
    homepage = "https://github.com/WojciechMula/pyahocorasick";
    changelog = "https://github.com/WojciechMula/pyahocorasick/blob/${version}/CHANGELOG.rst";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ fab ];
  };
}
