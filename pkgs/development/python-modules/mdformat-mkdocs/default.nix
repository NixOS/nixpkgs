{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  mdformat,
  mdformat-admon,
  mdformat-gfm,
  mdit-py-plugins,
  more-itertools,
  pythonOlder,
  pytest-snapshot,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "mdformat-mkdocs";
  version = "4.1.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "KyleKing";
    repo = "mdformat-mkdocs";
    tag = "v${version}";
    hash = "sha256-KH0edaqH5STRYtcSqbR0uTdlZVKuHRS7AUgd25fjvEE=";
  };

  nativeBuildInputs = [ flit-core ];

  propagatedBuildInputs = [
    mdformat
    mdformat-admon
    mdformat-gfm
    mdit-py-plugins
    more-itertools
  ];

  nativeCheckInputs = [
    pytest-snapshot
    pytestCheckHook
  ];

  disabledTestPaths = [
    # AssertionError: assert ParsedText(lines=[LineResult(parsed=ParsedLine(line_...
    "tests/format/test_parsed_result.py"
  ];

  pythonImportsCheck = [ "mdformat_mkdocs" ];

  meta = with lib; {
    description = "Mdformat plugin for MkDocs";
    homepage = "https://github.com/KyleKing/mdformat-mkdocs";
    changelog = "https://github.com/KyleKing/mdformat-mkdocs/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ aldoborrero ];
  };
}
