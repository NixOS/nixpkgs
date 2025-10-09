{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  markdown-it-py,
  mdformat,
  pytestCheckHook,
  pytest-cov-stub,
}:

buildPythonPackage rec {
  pname = "mdformat-wikilink";
  version = "0.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tmr232";
    repo = "mdformat-wikilink";
    tag = "v${version}";
    hash = "sha256-KOPh9iZfb3GCvslQeYBgqNaOyqtWi2llkaiWE7nmcJo=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    markdown-it-py
    mdformat
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
  ];

  pythonImportsCheck = [ "mdformat_wikilink" ];

  meta = {
    description = "Mdformat plugin for ensuring that wiki-style links are preserved during formatting";
    homepage = "https://github.com/tmr232/mdformat-wikilink";
    changelog = "https://github.com/tmr232/mdformat-wikilink/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mattkang ];
  };
}
