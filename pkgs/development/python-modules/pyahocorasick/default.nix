{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pyahocorasick";
  version = "2.2.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "WojciechMula";
    repo = "pyahocorasick";
    tag = "v${version}";
    hash = "sha256-lFJhHDN9QAKw5dqzgjRxcs+7+LuTqP9qQ68B5LlCNmU=";
  };

  build-system = [ setuptools ];

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
    changelog = "https://github.com/WojciechMula/pyahocorasick/blob/${src.tag}/CHANGELOG.rst";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fab ];
  };
}
