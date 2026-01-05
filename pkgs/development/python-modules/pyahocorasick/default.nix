{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pyahocorasick";
  version = "2.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "WojciechMula";
    repo = "pyahocorasick";
    tag = "v${version}";
    hash = "sha256-ysQZOyJZ9xrNp3plVpaDtGqzjNuRDAELtAcjbC8Byis=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "ahocorasick" ];

  meta = {
    description = "Python module implementing Aho-Corasick algorithm";
    longDescription = ''
      This Python module is a fast and memory efficient library for exact or
      approximate multi-pattern string search meaning that you can find multiple
      key strings occurrences at once in some input text.
    '';
    homepage = "https://github.com/WojciechMula/pyahocorasick";
    changelog = "https://github.com/WojciechMula/pyahocorasick/blob/${src.tag}/CHANGELOG.rst";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fab ];
  };
}
