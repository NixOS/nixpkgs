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
, typing-extensions
}:

buildPythonPackage rec {
  pname = "canals";
  version = "0.9.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "deepset-ai";
    repo = "canals";
    rev = "refs/tags/v${version}";
    hash = "sha256-5pRrpi1qxkFgGqcw7Nfc5rnOTra27H31DLKCglkPf6s=";
  };

  nativeBuildInputs = [
    hatchling
  ];

  propagatedBuildInputs = [
    networkx
    typing-extensions
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
    "test/pipeline/integration"
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
