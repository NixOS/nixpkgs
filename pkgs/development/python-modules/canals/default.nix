{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  mkdocs-material,
  mkdocs-mermaid2-plugin,
  mkdocstrings,
  networkx,
  pytestCheckHook,
  pythonOlder,
  requests,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "canals";
  version = "0.11.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "deepset-ai";
    repo = "canals";
    tag = "v${version}";
    hash = "sha256-xoJqj/zPBPPCheBxA+8EFRJqUnlP+4aWLEh42q1X1mM=";
  };

  nativeBuildInputs = [ hatchling ];

  propagatedBuildInputs = [
    networkx
    requests
    typing-extensions
  ];

  optional-dependencies = {
    docs = [
      mkdocs-material
      mkdocs-mermaid2-plugin
      mkdocstrings
    ];
  };

  nativeCheckInputs = [
    pytestCheckHook
  ]
  ++ lib.flatten (builtins.attrValues optional-dependencies);

  disabledTestPaths = [
    # Test requires internet connection to mermaid.ink
    "test/pipeline/integration"
  ];

  disabledTests = [
    # Path issue
    "test_draw_pygraphviz"
  ];

  pythonImportsCheck = [ "canals" ];

  meta = with lib; {
    description = "Component orchestration engine";
    homepage = "https://github.com/deepset-ai/canals";
    changelog = "https://github.com/deepset-ai/canals/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ happysalada ];
  };
}
