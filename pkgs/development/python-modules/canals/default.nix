{ lib
, buildPythonPackage
, pythonOlder
, pythonAtLeast
, fetchFromGitHub
# native build inputs
, hatchling
# build input
, networkx
# check inputs
, pytestCheckHook
# optional dependencies
, pygraphviz
, requests
, mkdocs-material
, mkdocs-mermaid2-plugin
, mkdocstrings
}:
let
  pname = "canals";
  version = "0.2.2";
  optional-dependencies = {
    graphviz = [ pygraphviz ];
    mermaid = [ requests ];
    docs = [ mkdocs-material mkdocs-mermaid2-plugin mkdocstrings ];
  };
in
buildPythonPackage {
  inherit version pname;
  format = "pyproject";

  # Pypi source package doesn't contain tests
  src = fetchFromGitHub {
    owner = "deepset-ai";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-dF0bkY4DFJIovaseNiOLgF8lmha+njTTTzr2/4LzZEc=";
  };

  disabled = pythonOlder "3.8";

  nativeBuildInputs = [
    hatchling
  ];

  propagatedBuildInputs = [
    networkx
  ];

  passthru = { inherit optional-dependencies; };

  nativeCheckInputs = [
    pytestCheckHook
  ] ++ optional-dependencies.mermaid;

  disabledTestPaths = [
    # requires internet connection to mermaid.ink
    "test/pipelines/integration"
  ];

  pythonImportsCheck = [ "canals" ];

  meta = with lib; {
    description = "A component orchestration engine";
    homepage = "https://github.com/deepset-ai/canals";
    changelog = "https://github.com/deepset-ai/canals/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ happysalada ];
  };
}
