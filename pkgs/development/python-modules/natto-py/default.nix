{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  cffi,
  unittestCheckHook,
  includeMecab ? true,
  mecab,
  pyyaml,
}:
let
  version = "1.0.1";
in
buildPythonPackage {
  inherit version;
  pname = "natto-py";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "buruzaemon";
    repo = "natto-py";
    tag = version;
    hash = "sha256-G7IYv5MNVfsTcTKQIMRAP9apTrMUo9+JnM3OWcV35X8=";
  };

  build-system = [
    setuptools
  ];

  propagatedBuildInputs = lib.optionals includeMecab [ mecab ];

  dependencies = [
    cffi
  ];

  nativeCheckInputs = [
    unittestCheckHook
    mecab
    pyyaml
  ];

  preCheck = ''
    export MECAB_PATH="${mecab}/lib/libmecab.so";
    export MECAB_CHARSET="utf8";
  '';

  pythonImportsCheck = [ "natto" ];

  meta = {
    homepage = "https://github.com/buruzaemon/natto-py";
    changelog = "https://raw.githubusercontent.com/buruzaemon/natto-py/refs/tags/${version}/CHANGELOG";
    description = "natto-py combines the Python programming language with MeCab, the part-of-speech and morphological analyzer for the Japanese language.";
    license = lib.licenses.bsd2;
    maintainers = [ ];
  };
}
