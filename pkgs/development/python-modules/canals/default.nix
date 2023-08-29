{ lib
, buildPythonPackage
, fetchFromGitHub
, hatchling
, mkdocs-material
, mkdocs-mermaid2-plugin
, mkdocstrings
, networkx
, pygraphviz
, pytestCheckHook
, pythonOlder
, requests
}:

buildPythonPackage rec {
  pname = "canals";
  version = "0.6.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "deepset-ai";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-s4nKPywfRn2hNhn/coWGqShv7D+MCEHblVzfweQJlnM=";
  };

  nativeBuildInputs = [
    hatchling
  ];

  propagatedBuildInputs = [
    networkx
  ];

  passthru.optional-dependencies = {
    graphviz = [
      pygraphviz
    ];
    mermaid = [
      requests
    ];
    docs = [
      mkdocs-material
      mkdocs-mermaid2-plugin
      mkdocstrings
    ];
  };

  nativeCheckInputs = [
    pytestCheckHook
  ] ++ lib.flatten (builtins.attrValues passthru.optional-dependencies);

  disabledTestPaths = [
    # Test requires internet connection to mermaid.ink
    "test/pipelines/integration"
  ];

  disabledTests = [
    # Path issue
    "test_draw_pygraphviz"
  ];

  pythonImportsCheck = [
    "canals"
  ];

  meta = with lib; {
    description = "A component orchestration engine";
    homepage = "https://github.com/deepset-ai/canals";
    changelog = "https://github.com/deepset-ai/canals/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ happysalada ];
  };
}
