{
  lib,
  fetchFromGitHub,
  pythonOlder,
  pytestCheckHook,
  buildPythonPackage,
  cython,
  mecab,
  setuptools-scm,
  ipadic,
  unidic,
  unidic-lite,
}:

buildPythonPackage rec {
  pname = "fugashi";
  version = "1.5.1";
  format = "pyproject";
  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "polm";
    repo = "fugashi";
    tag = "v${version}";
    hash = "sha256-rkQskRz7lgVBrqBeyj9kWO2/7POrZ0TaM+Z7mhpZLvM=";
  };

  nativeBuildInputs = [
    cython
    mecab
    setuptools-scm
  ];

  nativeCheckInputs = [
    ipadic
    pytestCheckHook
  ]
  ++ optional-dependencies.unidic-lite;

  optional-dependencies = {
    unidic-lite = [ unidic-lite ];
    unidic = [ unidic ];
  };

  preCheck = ''
    cd fugashi
  '';

  pythonImportsCheck = [ "fugashi" ];

  meta = with lib; {
    description = "Cython MeCab wrapper for fast, pythonic Japanese tokenization and morphological analysis";
    homepage = "https://github.com/polm/fugashi";
    changelog = "https://github.com/polm/fugashi/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ laurent-f1z1 ];
  };
}
