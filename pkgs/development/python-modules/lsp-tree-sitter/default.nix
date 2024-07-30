{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools-generate
, setuptools-scm
, colorama
, jinja2
, jsonschema
, pygls
, tree-sitter0_21
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "lsp-tree-sitter";
  version = "0.0.15";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "neomutt";
    repo = "lsp-tree-sitter";
    rev = version;
    hash = "sha256-yzScgix3BtSCBzlDoE1kMYGtVzkup/+ZK9L1C7VA3do=";
  };

  build-system = [
    setuptools-generate
    setuptools-scm
  ];

  dependencies = [
    colorama
    jinja2
    jsonschema
    pygls
    # The build won't fail if we had used tree-sitter (version > 0.21), but
    # this package is only a dependency of autotools-language-server which also
    # depends on tree-sitter-languages which must use tree-sitter0_21 and not
    # tree-sitter. Hence we avoid different tree-sitter versions dependency
    # mismatch by defaulting here to this lower version.
    tree-sitter0_21
  ];
  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "lsp_tree_sitter" ];

  meta = with lib; {
    description = "A library to create language servers";
    homepage = "https://github.com/neomutt/lsp-tree-sitter";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ doronbehar ];
  };
}
