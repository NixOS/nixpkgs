{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  regex,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "sentence-stream";
  version = "1.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "OHF-Voice";
    repo = "sentence-stream";
    tag = "v${version}";
    hash = "sha256-xGxgGOl8PM5Nc7ApeiRKdaKeoxsc/a7oBF+Ld+vtYDo=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    regex
  ];

  pythonRelaxDeps = [
    "regex"
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "sentence_stream"
  ];

  meta = {
    description = "A small sentence splitter for text streams";
    homepage = "https://github.com/OHF-Voice/sentence-stream";
    changelog = "https://github.com/OHF-Voice/sentence-stream/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ hexa ];
  };
}
