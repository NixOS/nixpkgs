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
  version = "2.0.11";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "KyleKing";
    repo = "mdformat-mkdocs";
    rev = "refs/tags/v${version}";
    hash = "sha256-wx95Lsqgi7fM/1s6fSHxXOs396mIR9S9yCRebC2VFpI=";
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
    changelog = "https://github.com/KyleKing/mdformat-mkdocs/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ aldoborrero ];
  };
}
