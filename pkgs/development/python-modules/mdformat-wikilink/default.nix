{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  markdown-it-py,
  mdformat,
  poetry-core,
  pytestCheckHook,
  pytest-cov,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "mdformat-wikilink";
  version = "0.2.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "tmr232";
    repo = "mdformat-wikilink";
    rev = "v${version}";
    hash = "sha256-KOPh9iZfb3GCvslQeYBgqNaOyqtWi2llkaiWE7nmcJo=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    markdown-it-py
    mdformat
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov
  ];

  pythonImportsCheck = [ "mdformat_wikilink" ];

  meta = with lib; {
    description = "Mdformat plugin for ensuring that wiki-style links are preserved during formatting";
    homepage = "https://github.com/tmr232/mdformat-wikilink";
    license = licenses.mit;
    maintainers = with maintainers; [ mattkang ];
  };
}
