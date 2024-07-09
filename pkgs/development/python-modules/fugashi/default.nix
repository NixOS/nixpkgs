{
  lib,
  fetchFromGitHub,
  pythonOlder,
  pytestCheckHook,
  buildPythonPackage,
  cython_0,
  mecab,
  setuptools-scm,
  ipadic,
  unidic,
  unidic-lite,
}:

buildPythonPackage rec {
  pname = "fugashi";
  version = "1.3.0";
  format = "setuptools";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "polm";
    repo = "fugashi";
    rev = "refs/tags/v${version}";
    hash = "sha256-4i7Q+TtXTQNSJ1EIcS8KHrVPdCJAgZh86Y6lB8772XU=";
  };

  nativeBuildInputs = [
    cython_0
    mecab
    setuptools-scm
  ];

  nativeCheckInputs = [
    ipadic
    pytestCheckHook
  ] ++ passthru.optional-dependencies.unidic-lite;

  passthru.optional-dependencies = {
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
