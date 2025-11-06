{
  lib,
  fetchFromGitHub,
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
  pyproject = true;

  src = fetchFromGitHub {
    owner = "polm";
    repo = "fugashi";
    tag = "v${version}";
    hash = "sha256-rkQskRz7lgVBrqBeyj9kWO2/7POrZ0TaM+Z7mhpZLvM=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "Cython~=3.0.11" "Cython"
  '';

  build-system = [
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
    changelog = "https://github.com/polm/fugashi/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ laurent-f1z1 ];
  };
}
